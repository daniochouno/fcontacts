//
//  SwiftFContactsHandler.swift
//
//
//  Created by Daniel Martínez on 03/10/2019.
//

import Foundation
import Contacts

public class SwiftFContactsHandler {

    static let instance = SwiftFContactsHandler()

    @available(iOS 9.0, *)
    func list( query: String? = nil, onSuccess: @escaping ([[String:Any]]) -> () ) {
        let store = CNContactStore()
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: Error?) -> Void in
                if authorized {
                    let list = self.retrieveContactsWithStore(store: store, query: query)
                    onSuccess( list )
                }
            })
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            let list = self.retrieveContactsWithStore(store: store, query: query)
            onSuccess( list )
        }
    }

    @available(iOS 9.0, *)
    private func retrieveContactsWithStore( store: CNContactStore, query: String? = nil ) -> [[String:Any]] {
        var list = [FContact]()
        var allContainers = [CNContainer]()
        do {
            allContainers = try store.containers(matching: nil)
        } catch {
            print("Exception: Fetching containers")
        }
        var keysToFetch : [CNKeyDescriptor] = [
            CNContactIdentifierKey as CNKeyDescriptor,
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactNamePrefixKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactMiddleNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPreviousFamilyNameKey as CNKeyDescriptor,
            CNContactNameSuffixKey as CNKeyDescriptor,
            CNContactNicknameKey as CNKeyDescriptor,
            CNContactPhoneticGivenNameKey as CNKeyDescriptor,
            CNContactPhoneticMiddleNameKey as CNKeyDescriptor,
            CNContactPhoneticFamilyNameKey as CNKeyDescriptor,
            CNContactJobTitleKey as CNKeyDescriptor,
            CNContactDepartmentNameKey as CNKeyDescriptor,
            CNContactOrganizationNameKey as CNKeyDescriptor,
            CNContactPostalAddressesKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactUrlAddressesKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactSocialProfilesKey as CNKeyDescriptor,
            CNContactBirthdayKey as CNKeyDescriptor,
            CNContactNonGregorianBirthdayKey as CNKeyDescriptor,
            CNContactDatesKey as CNKeyDescriptor,
            // TODO: To use <note> field, a permission has to be requested before to:
            //  https://developer.apple.com/contact/request/contact-note-field
            //CNContactNoteKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor,
            CNContactRelationsKey as CNKeyDescriptor,
            CNContactInstantMessageAddressesKey as CNKeyDescriptor,
            CNContactTypeKey as CNKeyDescriptor
        ]
        if #available(iOS 10.0, *) {
            keysToFetch.append( CNContactPhoneticOrganizationNameKey as CNKeyDescriptor )
        }
        for container in allContainers {
            let predicate = CNContact.predicateForContactsInContainer(
                withIdentifier: container.identifier
            )
            do {
                let contacts = try store.unifiedContacts(
                    matching: predicate,
                    keysToFetch: keysToFetch
                )
                for contact in contacts {
                    let model = fromCNContact( contact: contact )
                    if (contains( model: model, query: query )) {
                        list.append( model )
                    }
                }
            } catch {
                print("Exception: Fetching contacts")
            }
        }
        // Sort by displayName
        list.sort { (a, b) -> Bool in
            (a.displayName.lowercased() < b.displayName.lowercased())
        }
        return list.map { contact in
            return contact.toMap()
        }
    }

    @available(iOS 9.0, *)
    private func fromCNContact( contact: CNContact ) -> FContact {
        let model = FContact()
        model.identifier = contact.identifier
        if let fullName = CNContactFormatter.string(from: contact, style: .fullName) {
            model.displayName = fullName
        } else {
            model.displayName = contact.givenName + " " + contact.familyName
        }
        model.contactType = (contact.contactType == CNContactType.person) ? "person" : "organization"
        model.namePrefix = (contact.namePrefix.count > 0) ? contact.namePrefix : nil
        model.givenName = (contact.givenName.count > 0) ? contact.givenName : nil
        model.middleName = (contact.middleName.count > 0) ? contact.middleName : nil
        model.familyName = (contact.familyName.count > 0) ? contact.familyName : nil
        model.previousFamilyName = (contact.previousFamilyName.count > 0) ? contact.previousFamilyName : nil
        model.nameSuffix = (contact.nameSuffix.count > 0) ? contact.nameSuffix : nil
        model.nickname = (contact.nickname.count > 0) ? contact.nickname : nil
        model.phoneticGivenName = (contact.phoneticGivenName.count > 0) ? contact.phoneticGivenName : nil
        model.phoneticMiddleName = (contact.phoneticMiddleName.count > 0) ? contact.phoneticMiddleName : nil
        model.phoneticFamilyName = (contact.phoneticFamilyName.count > 0) ? contact.phoneticFamilyName : nil
        model.jobTitle = (contact.jobTitle.count > 0) ? contact.jobTitle : nil
        model.departmentName = (contact.departmentName.count > 0) ? contact.departmentName : nil
        model.organizationName = (contact.organizationName.count > 0) ? contact.organizationName : nil
        if #available(iOS 10.0, *) {
            model.phoneticOrganizationName = (contact.phoneticOrganizationName.count > 0) ? contact.phoneticOrganizationName : nil
        }
        if let birthday = contact.birthday {
            if let day = birthday.day {
                model.birthdayDay = day
            }
            if let month = birthday.month {
                model.birthdayMonth = month
            }
            if let year = birthday.year {
                model.birthdayYear = year
            }
        } else if let birthday = contact.nonGregorianBirthday {
            if let day = birthday.day {
                model.birthdayDay = day
            }
            if let month = birthday.month {
                model.birthdayMonth = month
            }
            if let year = birthday.year {
                model.birthdayYear = year
            }
        }
        for labeledDate in contact.dates {
            let _labeled = FContactDateLabeled()
            if let label = labeledDate.label {
                _labeled.label = CNLabeledValue<NSDateComponents>.localizedString(forLabel: label)
            } else {
                _labeled.label = "unknown"
            }
            _labeled.valueDay = labeledDate.value.day
            _labeled.valueMonth = labeledDate.value.month
            if labeledDate.value.year != .max {
                _labeled.valueYear = labeledDate.value.year
            }
            model.dates.append( _labeled )
        }
        model.imageDataAvailable = contact.imageDataAvailable
        if (contact.imageDataAvailable) {
            model.imageData = contact.imageData
            model.thumbnailImageData = contact.thumbnailImageData
        }
        for labeledPostalAddress in contact.postalAddresses {
            let _labeled = FContactPostalAddressLabeled()
            if let label = labeledPostalAddress.label {
                _labeled.label = CNLabeledValue<CNPostalAddress>.localizedString(forLabel: label)
            } else {
                _labeled.label = "unknown"
            }
            _labeled.valueStreet = (labeledPostalAddress.value.street.count > 0) ? labeledPostalAddress.value.street : nil
            _labeled.valueCity = (labeledPostalAddress.value.city.count > 0) ? labeledPostalAddress.value.city : nil
            if #available(iOS 10.3, *) {
                _labeled.valueSubLocality = (labeledPostalAddress.value.subLocality.count > 0) ? labeledPostalAddress.value.subLocality : nil
                _labeled.valueSubAdministrativeArea = (labeledPostalAddress.value.subAdministrativeArea.count > 0) ? labeledPostalAddress.value.subAdministrativeArea : nil
            }
            _labeled.valuePostalCode = (labeledPostalAddress.value.postalCode.count > 0) ? labeledPostalAddress.value.postalCode : nil
            _labeled.valueState = (labeledPostalAddress.value.state.count > 0) ? labeledPostalAddress.value.state : nil
            _labeled.valueCountry = (labeledPostalAddress.value.country.count > 0) ? labeledPostalAddress.value.country : nil
            _labeled.valueISOCountryCode = (labeledPostalAddress.value.isoCountryCode.count > 0) ? labeledPostalAddress.value.isoCountryCode : nil
            let formatted = CNPostalAddressFormatter.string(
                from: labeledPostalAddress.value,
                style: .mailingAddress
            )
            _labeled.formatted = formatted
            model.postalAddresses.append( _labeled )
        }
        for labeledEmail in contact.emailAddresses {
            let _labeled = FContactValueLabeled()
            if let label = labeledEmail.label {
                _labeled.label = CNLabeledValue<NSString>.localizedString(forLabel: label)
            } else {
                _labeled.label = "unknown"
            }
            _labeled.value = labeledEmail.value as String
            model.emails.append( _labeled )
        }
        for labeledUrl in contact.urlAddresses {
            let _labeled = FContactValueLabeled()
            if let label = labeledUrl.label {
                _labeled.label = CNLabeledValue<NSString>.localizedString(forLabel: label)
            } else {
                _labeled.label = "unknown"
            }
            _labeled.value = labeledUrl.value as String
            model.urls.append( _labeled )
        }
        for labeledPhoneNumber in contact.phoneNumbers {
            let _labeled = FContactValueLabeled()
            if let label = labeledPhoneNumber.label {
                _labeled.label = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
            } else {
                _labeled.label = "unknown"
            }
            _labeled.value = labeledPhoneNumber.value.stringValue
            model.phoneNumbers.append( _labeled )
        }
        for labeledSocialProfile in contact.socialProfiles {
            let _labeled = FContactSocialProfileLabeled()
            if let label = labeledSocialProfile.label {
                _labeled.label = CNLabeledValue<CNSocialProfile>.localizedString(forLabel: label)
            } else {
                _labeled.label = "unknown"
            }
            _labeled.valueService = labeledSocialProfile.value.service
            _labeled.valueUserIdentifier = labeledSocialProfile.value.userIdentifier
            _labeled.valueUsername = labeledSocialProfile.value.username
            _labeled.valueUrl = labeledSocialProfile.value.urlString
            model.socialProfiles.append( _labeled )
        }
        for labeledContactRelation in contact.contactRelations {
            let _labeled = FContactValueLabeled()
            if let label = labeledContactRelation.label {
                _labeled.label = CNLabeledValue<CNContactRelation>.localizedString(forLabel: label)
            } else {
                _labeled.label = "unknown"
            }
            _labeled.value = labeledContactRelation.value.name
            model.contactRelations.append( _labeled )
        }
        for labeledInstantMessageAddress in contact.instantMessageAddresses {
            let _labeled = FContactInstantMessageAddressLabeled()
            if let label = labeledInstantMessageAddress.label {
                _labeled.label = CNLabeledValue<CNInstantMessageAddress>.localizedString(forLabel: label)
            } else {
                _labeled.label = "unknown"
            }
            _labeled.valueService = labeledInstantMessageAddress.value.service
            _labeled.valueUsername = labeledInstantMessageAddress.value.username
            model.instantMessageAddresses.append( _labeled )
        }
        return model
    }

    private func contains( model: FContact, query: String? = nil ) -> Bool {
        guard let query = query else {
            return true
        }
        let _query = query.lowercased()
        if (model.displayName.lowercased().contains( _query )) {
            return true
        }
        if (model.identifier.lowercased().contains( _query )) {
            return true
        }
        if let _value = model.nickname, (_value.lowercased().contains( _query )) {
            return true
        }
        if let _value = model.jobTitle, (_value.lowercased().contains( _query )) {
            return true
        }
        if let _value = model.departmentName, (_value.lowercased().contains( _query )) {
            return true
        }
        if let _value = model.organizationName, (_value.lowercased().contains( _query )) {
            return true
        }
        for postalAddress in model.postalAddresses {
            if let _value = postalAddress.valueStreet, (_value.lowercased().contains( _query )) {
                return true
            }
            if let _value = postalAddress.valueCity, (_value.lowercased().contains( _query )) {
                return true
            }
            if let _value = postalAddress.valueSubLocality, (_value.lowercased().contains( _query )) {
                return true
            }
            if let _value = postalAddress.valueSubAdministrativeArea, (_value.lowercased().contains( _query )) {
                return true
            }
            if let _value = postalAddress.valueState, (_value.lowercased().contains( _query )) {
                return true
            }
            if let _value = postalAddress.valuePostalCode, (_value.lowercased().contains( _query )) {
                return true
            }
            if let _value = postalAddress.valueCountry, (_value.lowercased().contains( _query )) {
                return true
            }
        }
        for email in model.emails {
            if (email.value.lowercased().contains( _query )) {
                return true
            }
        }
        for url in model.urls {
            if (url.value.lowercased().contains( _query )) {
                return true
            }
        }
        for phoneNumber in model.phoneNumbers {
            if (phoneNumber.value.lowercased().contains( _query )) {
                return true
            }
        }
        for socialProfile in model.socialProfiles {
            if let _value = socialProfile.valueService, (_value.lowercased().contains( _query )) {
                return true
            }
            if let _value = socialProfile.valueUserIdentifier, (_value.lowercased().contains( _query )) {
                return true
            }
            if let _value = socialProfile.valueUsername, (_value.lowercased().contains( _query )) {
                return true
            }
            if let _value = socialProfile.valueUrl, (_value.lowercased().contains( _query )) {
                return true
            }
        }
        for relation in model.contactRelations {
            if (relation.value.lowercased().contains( _query )) {
                return true
            }
        }
        for instantMessageAddress in model.instantMessageAddresses {
            if let _value = instantMessageAddress.valueService, (_value.lowercased().contains( _query )) {
                return true
            }
            if let _value = instantMessageAddress.valueUsername, (_value.lowercased().contains( _query )) {
                return true
            }
        }
        return false
    }

}
