package info.danielmartinez.fcontacts

import android.content.ContentResolver
import android.content.Context
import android.database.Cursor
import android.database.Cursor.*
import android.net.Uri
import android.os.Build
import android.provider.ContactsContract
import android.provider.ContactsContract.CommonDataKinds.Event.TYPE_BIRTHDAY
import kotlinx.coroutines.*

class FContactsHandler (
    private val contentResolver: ContentResolver,
    private val context: Context
) {

    private val parentJob = Job()
    private val exceptionHandler : CoroutineExceptionHandler = CoroutineExceptionHandler {
        _, throwable ->
        GlobalScope.launch {
            println("CoRoutineException Caught: $throwable")
        }
    }
    private val scope = CoroutineScope( Dispatchers.Default + parentJob + exceptionHandler )

    fun list( onSuccess: (contacts: List<Map<String,Any>>) -> Unit ) {
        scope.launch( Dispatchers.Main ) {
            val items = asyncList()
            onSuccess( items )
        }
    }

    private suspend fun asyncList() : List<Map<String,Any>> =
            scope.async {
                return@async query()
            }.await()

    private fun query() : List<Map<String,Any>> {
        val list = ArrayList<FContact>()
        val result = ArrayList<Map<String,Any>>()
        val resolver : ContentResolver = this.contentResolver
        val uri = ContactsContract.Contacts.CONTENT_URI

        val cursor = resolver.query(
            uri,
            null,
            null,
            null,
            null
        ) as Cursor
        if (cursor.count > 0) {
            while (cursor.moveToNext()) {
                val model = fromCursor( cursor )
                if ((model != null) && (!list.contains( model ))) {
                    list.add( model )
                    result.add( model.toMap() )
                }
            }
        }
        cursor.close()
        return result
    }

    private fun fromCursor(cursor: Cursor): FContact? {
        val columnIndexID = cursor.getColumnIndex(
            ContactsContract.Contacts._ID
        )
        if (columnIndexID == -1) {
            return null
        }
        val identifier = cursor.getString( columnIndexID )
        val model = FContact( identifier )
        val columnIndexDisplayName = cursor.getColumnIndex(
                ContactsContract.Contacts.DISPLAY_NAME
        )
        val displayName = cursor.getString( columnIndexDisplayName )
        model.displayName = displayName
        model.contactType = "person"
        val columnIndexPhotoUri = cursor.getColumnIndex(
                ContactsContract.Contacts.PHOTO_URI
        )
        if (columnIndexPhotoUri != -1) {
            val photoString = cursor.getString( columnIndexPhotoUri )
            if (photoString != null) {
                val uri = Uri.parse( photoString )
                val bytes = contentResolver.openInputStream( uri )?.buffered()?.use { it.readBytes() }
                model.imageData = bytes
                model.imageDataAvailable = true
            }
        }
        val columnIndexPhotoThumbnailUri = cursor.getColumnIndex(
                ContactsContract.Contacts.PHOTO_THUMBNAIL_URI
        )
        if (columnIndexPhotoThumbnailUri != -1) {
            val thumbnailString = cursor.getString( columnIndexPhotoThumbnailUri )
            if (thumbnailString != null) {
                val uri = Uri.parse( thumbnailString )
                val bytes = contentResolver.openInputStream( uri )?.buffered()?.use { it.readBytes() }
                model.thumbnailData = bytes
                model.imageDataAvailable = true
            }
        }
        val columnIndexHasPhoneNumber = cursor.getColumnIndex(
                ContactsContract.Contacts.HAS_PHONE_NUMBER
        )
        val hasPhoneNumber = cursor.getInt( columnIndexHasPhoneNumber )
        if (hasPhoneNumber == 1) {
            val cursorPhoneNumbers = contentResolver.query(
                ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                null,
                ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = " + identifier,
                null,
                null
            )
            val listPhoneNumbers = ArrayList<FContactValueLabeled>()
            while( cursorPhoneNumbers!!.moveToNext() ) {
                val columnIndexNumber = cursorPhoneNumbers.getColumnIndex(
                        ContactsContract.CommonDataKinds.Phone.NUMBER
                )
                if (columnIndexNumber != -1) {
                    val number = cursorPhoneNumbers.getString(columnIndexNumber)
                    val columnIndexType = cursorPhoneNumbers.getColumnIndex( ContactsContract.CommonDataKinds.Phone.TYPE )
                    val type = cursorPhoneNumbers.getInt( columnIndexType )
                    val columnIndexLabel = cursorPhoneNumbers.getColumnIndex( ContactsContract.CommonDataKinds.Phone.LABEL )
                    val label = cursorPhoneNumbers.getString( columnIndexLabel )
                    val formattedLabel = ContactsContract.CommonDataKinds.Phone.getTypeLabel(
                        context.resources,
                        type,
                        label
                    ) as String
                    listPhoneNumbers.add( FContactValueLabeled( formattedLabel, number ) )
                }
            }
            cursorPhoneNumbers.close()
            model.phoneNumbers = listPhoneNumbers
        }
        val emails = contentResolver.query(
            ContactsContract.CommonDataKinds.Email.CONTENT_URI,
            null,
            ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = " + identifier,
            null,
            null
        )
        val listEmails = ArrayList<FContactValueLabeled>()
        while( emails!!.moveToNext() ) {
            val address = emails.getString(emails.getColumnIndex(
                    ContactsContract.CommonDataKinds.Email.ADDRESS
            ))
            val type = emails.getInt( emails.getColumnIndex( ContactsContract.CommonDataKinds.Email.TYPE ) )
            val label = emails.getString( emails.getColumnIndex( ContactsContract.CommonDataKinds.Email.LABEL ) )
            val formattedLabel = ContactsContract.CommonDataKinds.Email.getTypeLabel(
                context.resources,
                type,
                label
            ).toString()
            listEmails.add( FContactValueLabeled( formattedLabel, address ) )
        }
        emails.close()
        model.emails = listEmails

        // Postal Addresses
        val cursorPostalAddress = contentResolver.query(
                ContactsContract.CommonDataKinds.StructuredPostal.CONTENT_URI,
                null,
                ContactsContract.CommonDataKinds.StructuredPostal.CONTACT_ID + " = " + identifier,
                null,
                null
        )
        val listPostalAddresses = ArrayList<FContactPostalAddressLabeled>()
        while( cursorPostalAddress!!.moveToNext() ) {
            val columnIndexType = cursorPostalAddress.getColumnIndex( ContactsContract.CommonDataKinds.StructuredPostal.TYPE )
            val type = cursorPostalAddress.getInt( columnIndexType )
            val columnIndexLabel = cursorPostalAddress.getColumnIndex( ContactsContract.CommonDataKinds.StructuredPostal.LABEL )
            val label = cursorPostalAddress.getString( columnIndexLabel )
            val formattedLabel = ContactsContract.CommonDataKinds.StructuredPostal.getTypeLabel(
                    context.resources,
                    type,
                    label
            ) as String
            val fPostalAddress = FContactPostalAddressLabeled( formattedLabel )
            val columnIndexFormattedAddress = cursorPostalAddress.getColumnIndex(
                    ContactsContract.CommonDataKinds.StructuredPostal.FORMATTED_ADDRESS
            )
            if (columnIndexFormattedAddress != -1) {
                val formattedAddress = cursorPostalAddress.getString(columnIndexFormattedAddress)
                fPostalAddress.formatted = formattedAddress
            }
            val columnIndexStreet = cursorPostalAddress.getColumnIndex(
                    ContactsContract.CommonDataKinds.StructuredPostal.STREET
            )
            if (columnIndexStreet != -1) {
                val street = cursorPostalAddress.getString(columnIndexStreet)
                fPostalAddress.street = street
            }
            val columnIndexCity = cursorPostalAddress.getColumnIndex(
                    ContactsContract.CommonDataKinds.StructuredPostal.CITY
            )
            if (columnIndexCity != -1) {
                val city = cursorPostalAddress.getString(columnIndexCity)
                fPostalAddress.city = city
            }
            val columnIndexNeighborhood = cursorPostalAddress.getColumnIndex(
                    ContactsContract.CommonDataKinds.StructuredPostal.NEIGHBORHOOD
            )
            if (columnIndexNeighborhood != -1) {
                val neighborhood = cursorPostalAddress.getString(columnIndexNeighborhood)
                fPostalAddress.neighborhood = neighborhood
            }
            val columnIndexPobox = cursorPostalAddress.getColumnIndex(
                    ContactsContract.CommonDataKinds.StructuredPostal.POBOX
            )
            if (columnIndexPobox != -1) {
                val pobox = cursorPostalAddress.getString(columnIndexPobox)
                fPostalAddress.pobox = pobox
            }
            val columnIndexRegion = cursorPostalAddress.getColumnIndex(
                    ContactsContract.CommonDataKinds.StructuredPostal.REGION
            )
            if (columnIndexRegion != -1) {
                val region = cursorPostalAddress.getString(columnIndexRegion)
                fPostalAddress.region = region
            }
            val columnIndexPostcode = cursorPostalAddress.getColumnIndex(
                    ContactsContract.CommonDataKinds.StructuredPostal.POSTCODE
            )
            if (columnIndexPostcode != -1) {
                val postcode = cursorPostalAddress.getString(columnIndexPostcode)
                fPostalAddress.postcode = postcode
            }
            val columnIndexCountry = cursorPostalAddress.getColumnIndex(
                    ContactsContract.CommonDataKinds.StructuredPostal.COUNTRY
            )
            if (columnIndexCountry != -1) {
                val country = cursorPostalAddress.getString(columnIndexCountry)
                fPostalAddress.country = country
            }
            listPostalAddresses.add( fPostalAddress )
        }
        cursorPostalAddress.close()
        model.postalAddresses = listPostalAddresses

        // Data
        val cursorData = contentResolver.query(
                ContactsContract.Data.CONTENT_URI,
                null,
                ContactsContract.Data.CONTACT_ID + " = " + identifier,
                null,
                null
        ) as Cursor

        val listEvents = ArrayList<FContactDateLabeled>()
        val listIMAddresses = ArrayList<FContactInstantMessageAddressLabeled>()
        val listURLs = ArrayList<FContactValueLabeled>()
        val listRelations = ArrayList<FContactValueLabeled>()
        while( cursorData.moveToNext() ) {

            val columnIndexMimeType = cursorData.getColumnIndex(
                ContactsContract.Data.MIMETYPE
            )
            if (columnIndexMimeType != -1) {
                val mimetype = cursorData.getString( columnIndexMimeType )
                if (mimetype.equals( ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE )) {
                    val columnIndexGivenName = cursorData.getColumnIndex(
                        ContactsContract.CommonDataKinds.StructuredName.GIVEN_NAME
                    )
                    if (columnIndexGivenName != -1) {
                        val givenName = cursorData.getString( columnIndexGivenName )
                        model.givenName = givenName
                    }
                    val columnIndexMiddleName = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.StructuredName.MIDDLE_NAME
                    )
                    if (columnIndexMiddleName != -1) {
                        val middleName = cursorData.getString( columnIndexMiddleName )
                        model.middleName = middleName
                    }
                    val columnIndexFamilyName = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.StructuredName.FAMILY_NAME
                    )
                    if (columnIndexFamilyName != -1) {
                        val familyName = cursorData.getString( columnIndexFamilyName )
                        model.familyName = familyName
                    }
                    val columnIndexPrefixName = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.StructuredName.PREFIX
                    )
                    if (columnIndexPrefixName != -1) {
                        val namePrefix = cursorData.getString( columnIndexPrefixName )
                        model.namePrefix = namePrefix
                    }
                    val columnIndexSuffixName = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.StructuredName.SUFFIX
                    )
                    if (columnIndexSuffixName != -1) {
                        val nameSuffix = cursorData.getString( columnIndexSuffixName )
                        model.nameSuffix = nameSuffix
                    }
                } else if (mimetype.equals( ContactsContract.CommonDataKinds.Nickname.CONTENT_ITEM_TYPE )) {
                    val columnIndexNickname = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.Nickname.NAME
                    )
                    if (columnIndexNickname != -1) {
                        val nickname = cursorData.getString( columnIndexNickname )
                        model.nickname = nickname
                    }
                } else if (mimetype.equals( ContactsContract.CommonDataKinds.Note.CONTENT_ITEM_TYPE )) {
                    val columnIndexNote = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.Note.NOTE
                    )
                    if (columnIndexNote != -1) {
                        val note = cursorData.getString( columnIndexNote )
                        model.note = note
                    }
                } else if (mimetype.equals( ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE )) {
                    val columnIndexCompany = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.Organization.COMPANY
                    )
                    if (columnIndexCompany != -1) {
                        val company = cursorData.getString( columnIndexCompany )
                        model.organizationName = company
                    }
                    val columnIndexJobTitle = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.Organization.TITLE
                    )
                    if (columnIndexJobTitle != -1) {
                        val jobTitle = cursorData.getString( columnIndexJobTitle )
                        model.jobTitle = jobTitle
                    }
                } else if (mimetype.equals( ContactsContract.CommonDataKinds.Event.CONTENT_ITEM_TYPE )) {
                    val columnIndexType = cursorData.getColumnIndex( ContactsContract.CommonDataKinds.Event.TYPE )
                    val type = cursorData.getInt( columnIndexType )
                    val columnIndexLabel = cursorData.getColumnIndex( ContactsContract.CommonDataKinds.Event.LABEL )
                    val label = cursorData.getString( columnIndexLabel )
                    val columnIndexStartDate = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.Event.START_DATE
                    )
                    if (columnIndexStartDate != -1) {
                        val startDate = cursorData.getString(columnIndexStartDate)
                        val componentDates = startDate.split("-")
                        var componentDay : Int? = null
                        var componentMonth : Int? = null
                        var componentYear : Int? = null
                        if (componentDates.size == 3) {
                            componentDay = componentDates[2].toInt()
                            componentMonth = componentDates[1].toInt()
                            componentYear = componentDates[0].toInt()
                        } else if (componentDates.size == 2) {
                            componentDay = componentDates[1].toInt()
                            componentMonth = componentDates[0].toInt()
                        } else if (componentDates.size == 1) {
                            componentDay = componentDates[0].toInt()
                        }
                        if ((componentDay != null) && (componentMonth != null) && (componentYear != null)) {
                            if (type == TYPE_BIRTHDAY) {
                                model.birthdayDay = componentDay
                                model.birthdayMonth = componentMonth
                                model.birthdayYear = componentYear
                            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                val formattedLabel = ContactsContract.CommonDataKinds.Event.getTypeLabel(
                                        context.resources,
                                        type,
                                        label
                                ) as String
                                listEvents.add(FContactDateLabeled(formattedLabel, componentDay, componentMonth, componentYear))
                            } else {
                                listEvents.add(FContactDateLabeled("event", componentDay, componentMonth, componentYear))
                            }
                        }
                    }
                } else if (mimetype.equals( ContactsContract.CommonDataKinds.Im.CONTENT_ITEM_TYPE )) {
                    val columnIndexType = cursorData.getColumnIndex( ContactsContract.CommonDataKinds.Im.TYPE )
                    val type = cursorData.getInt( columnIndexType )
                    val columnIndexLabel = cursorData.getColumnIndex( ContactsContract.CommonDataKinds.Im.LABEL )
                    val label = cursorData.getString( columnIndexLabel )
                    val formattedLabel = ContactsContract.CommonDataKinds.Im.getTypeLabel(
                            context.resources,
                            type,
                            label
                    ) as String
                    val fIMAddress = FContactInstantMessageAddressLabeled( formattedLabel )
                    val columnIndexData = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.Im.DATA
                    )
                    if (columnIndexData != -1) {
                        val data = cursorData.getString(columnIndexData)
                        fIMAddress.username = data
                    }
                    val columnIndexProtocol = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.Im.PROTOCOL
                    )
                    if (columnIndexProtocol != -1) {
                        val protocol = cursorData.getInt(columnIndexProtocol)
                        val formattedProtocol = ContactsContract.CommonDataKinds.Im.getProtocolLabel(
                                context.resources,
                                protocol,
                                label
                        ) as String
                        fIMAddress.service = formattedProtocol
                    }
                    listIMAddresses.add( fIMAddress )
                } else if (mimetype.equals( ContactsContract.CommonDataKinds.Relation.CONTENT_ITEM_TYPE )) {
                    val columnIndexType = cursorData.getColumnIndex( ContactsContract.CommonDataKinds.Relation.TYPE )
                    val type = cursorData.getInt( columnIndexType )
                    val columnIndexLabel = cursorData.getColumnIndex( ContactsContract.CommonDataKinds.Relation.LABEL )
                    val label = cursorData.getString( columnIndexLabel )
                    val formattedLabel = ContactsContract.CommonDataKinds.Relation.getTypeLabel(
                            context.resources,
                            type,
                            label
                    ) as String
                    val fRelation = FContactValueLabeled( formattedLabel )
                    val columnIndexName = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.Relation.NAME
                    )
                    if (columnIndexName != -1) {
                        val name = cursorData.getString(columnIndexName)
                        fRelation.value = name
                    }
                    listRelations.add( fRelation )
                } else if (mimetype.equals( ContactsContract.CommonDataKinds.Website.CONTENT_ITEM_TYPE )) {
                    //val columnIndexType = cursorData.getColumnIndex( ContactsContract.CommonDataKinds.Website.TYPE )
                    //val type = cursorData.getInt( columnIndexType )
                    //val columnIndexLabel = cursorData.getColumnIndex( ContactsContract.CommonDataKinds.Website.LABEL )
                    //val label = cursorData.getString( columnIndexLabel )
                    val fUrl = FContactValueLabeled( "website" )
                    val columnIndexUrl = cursorData.getColumnIndex(
                            ContactsContract.CommonDataKinds.Website.URL
                    )
                    if (columnIndexUrl != -1) {
                        val url = cursorData.getString(columnIndexUrl)
                        fUrl.value = url
                    }
                    listURLs.add( fUrl )
                }
            }
        }
        cursorData.close()

        model.dates = listEvents
        model.instantMessageAddresses = listIMAddresses
        model.contactRelations = listRelations
        model.urls = listURLs

        return model

    }

}