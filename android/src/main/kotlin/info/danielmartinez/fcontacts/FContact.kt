package info.danielmartinez.fcontacts

class FContact (
    val identifier: String,
    var displayName : String? = null,
    var contactType : String? = null,
    var namePrefix : String? = null,
    var givenName : String? = null,
    var middleName : String? = null,
    var familyName : String? = null,
    var nameSuffix : String? = null,
    var nickname : String? = null,
    var jobTitle : String? = null,
    var organizationName : String? = null,
    var birthdayDay : Int? = null,
    var birthdayMonth : Int? = null,
    var birthdayYear : Int? = null,
    var note : String? = null,
    var imageData : ByteArray? = null,
    var thumbnailData : ByteArray? = null,
    var imageDataAvailable : Boolean = false,
    var dates : List<FContactDateLabeled>? = null,  // TODO
    var postalAddresses : List<FContactPostalAddressLabeled>? = null,       // TODO
    var emails : List<FContactValueLabeled>? = null,
    var urls : List<FContactValueLabeled>? = null,
    var phoneNumbers : List<FContactValueLabeled>? = null,
    var socialProfiles : List<FContactSocialProfileLabeled>? = null,
    var contactRelations : List<FContactValueLabeled>? = null,
    var instantMessageAddresses : List<FContactInstantMessageAddressLabeled>? = null    // TODO
) : Comparable<FContact> {

    override fun compareTo( other: FContact ): Int {
        return other.identifier.compareTo( this.identifier )
    }

    fun toMap() : Map<String,Any> {
        val map = mutableMapOf<String,Any>(
            "identifier" to this.identifier,
            "displayName" to if (this.displayName != null) this.displayName as String else ""
        )
        if (this.contactType != null) {
            map["contactType"] = this.contactType as String
        }
        if (this.namePrefix != null) {
            map["namePrefix"] = this.namePrefix as String
        }
        if (this.givenName != null) {
            map["givenName"] = this.givenName as String
        }
        if (this.middleName != null) {
            map["middleName"] = this.middleName as String
        }
        if (this.familyName != null) {
            map["familyName"] = this.familyName as String
        }
        if (this.nameSuffix != null) {
            map["nameSuffix"] = this.nameSuffix as String
        }
        if (this.jobTitle != null) {
            map["jobTitle"] = this.jobTitle as String
        }
        if (this.organizationName != null) {
            map["organizationName"] = this.organizationName as String
        }
        if (this.birthdayDay != null) {
            map["birthdayDay"] = this.birthdayDay as Int
        }
        if (this.birthdayMonth != null) {
            map["birthdayMonth"] = this.birthdayMonth as Int
        }
        if (this.birthdayYear != null) {
            map["birthdayYear"] = this.birthdayYear as Int
        }
        if (this.nickname != null) {
            map["nickname"] = this.nickname as String
        }
        if (this.note != null) {
            map["note"] = this.note as String
        }
        if (this.imageDataAvailable) {
            if (this.imageData != null) {
                map["imageData"] = this.imageData as ByteArray
            }
            if (this.thumbnailData != null) {
                map["thumbnailData"] = this.thumbnailData as ByteArray
            }
        }
        if ((this.emails != null) && (this.emails!!.isNotEmpty())) {
            val list = ArrayList<Map<String,Any>>()
            this.emails!!.forEach { email ->
                list.add( email.toMap() )
            }
            map["emails"] = list
        }
        if ((this.phoneNumbers != null) && (this.phoneNumbers!!.isNotEmpty())) {
            val list = ArrayList<Map<String,Any>>()
            this.phoneNumbers!!.forEach { phoneNumber ->
                list.add( phoneNumber.toMap() )
            }
            map["phoneNumbers"] = list
        }
        if ((this.postalAddresses != null) && (this.postalAddresses!!.isNotEmpty())) {
            val list = ArrayList<Map<String,Any>>()
            this.postalAddresses!!.forEach { postalAddress ->
                list.add( postalAddress.toMap() )
            }
            map["postalAddresses"] = list
        }
        if ((this.dates != null) && (this.dates!!.isNotEmpty())) {
            val list = ArrayList<Map<String,Any>>()
            this.dates!!.forEach { date ->
                list.add( date.toMap() )
            }
            map["dates"] = list
        }
        if ((this.urls != null) && (this.urls!!.isNotEmpty())) {
            val list = ArrayList<Map<String,Any>>()
            this.urls!!.forEach { url ->
                list.add( url.toMap() )
            }
            map["urls"] = list
        }
        if ((this.socialProfiles != null) && (this.socialProfiles!!.isNotEmpty())) {
            val list = ArrayList<Map<String,Any>>()
            this.socialProfiles!!.forEach { socialProfile ->
                list.add( socialProfile.toMap() )
            }
            map["socialProfiles"] = list
        }
        if ((this.contactRelations != null) && (this.contactRelations!!.isNotEmpty())) {
            val list = ArrayList<Map<String,Any>>()
            this.contactRelations!!.forEach { contactRelation ->
                list.add( contactRelation.toMap() )
            }
            map["contactRelations"] = list
        }
        if ((this.instantMessageAddresses != null) && (this.instantMessageAddresses!!.isNotEmpty())) {
            val list = ArrayList<Map<String,Any>>()
            this.instantMessageAddresses!!.forEach { instantMessageAddress ->
                list.add( instantMessageAddress.toMap() )
            }
            map["instantMessageAddresses"] = list
        }
        return map
    }

}

class FContactValueLabeled (
    private val label: String,
    var value : String? = null
) {
    fun toMap() : Map<String,Any> {
        return mapOf( Pair(this.label, this.value as String) )
    }
}

class FContactDateLabeled (
    private val label: String,
    var day : Int? = null,
    var month : Int? = null,
    var year : Int? = null
) {
    fun toMap() : Map<String,Any> {
        val map = mutableMapOf<String,Any>(
            Pair( "label", this.label )
        )
        if (this.day != null) {
            map[ "day" ] = this.day as Int
        }
        if (this.month != null) {
            map[ "month" ] = this.month as Int
        }
        if (this.year != null) {
            map[ "year" ] = this.year as Int
        }
        return map
    }
}

class FContactPostalAddressLabeled (
    private val label: String,
    var street : String? = null,
    var city : String? = null,
    var neighborhood : String? = null,
    var pobox : String? = null,
    var region : String? = null,
    var postcode : String? = null,
    var country : String? = null,
    var formatted : String? = null
) {
    fun toMap() : Map<String,Any> {
        val map = mutableMapOf<String,Any>(
                Pair( "label", this.label )
        )
        if (this.street != null) {
            map[ "street" ] = this.street as String
        }
        if (this.city != null) {
            map[ "city" ] = this.city as String
        }
        if (this.neighborhood != null) {
            map[ "subLocality" ] = this.neighborhood as String
        }
        if (this.pobox != null) {
            map[ "subAdministrativeArea" ] = this.pobox as String
        }
        if (this.region != null) {
            map[ "state" ] = this.region as String
        }
        if (this.postcode != null) {
            map[ "postalCode" ] = this.postcode as String
        }
        if (this.country != null) {
            map[ "country" ] = this.country as String
        }
        if (this.formatted != null) {
            map[ "formatted" ] = this.formatted as String
        }
        return map
    }
}

class FContactSocialProfileLabeled (
        private val label: String,
        var service : String? = null,
        var userIdentifier : String? = null,
        var username : String? = null,
        var url : String? = null
) {
    fun toMap() : Map<String,Any> {
        val map = mutableMapOf<String,Any>(
                Pair( "label", this.label )
        )
        if (this.service != null) {
            map[ "service" ] = this.service as String
        }
        if (this.userIdentifier != null) {
            map[ "userIdentifier" ] = this.userIdentifier as String
        }
        if (this.username != null) {
            map[ "username" ] = this.username as String
        }
        if (this.url != null) {
            map[ "url" ] = this.url as String
        }
        return map
    }
}

class FContactInstantMessageAddressLabeled (
        private val label: String,
        var service : String? = null,
        var username : String? = null
) {
    fun toMap() : Map<String,Any> {
        val map = mutableMapOf<String,Any>(
            Pair( "label", this.label )
        )
        if (this.service != null) {
            map[ "service" ] = this.service as String
        }
        if (this.username != null) {
            map[ "username" ] = this.username as String
        }
        return map
    }
}
