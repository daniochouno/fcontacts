//
//  FContact.swift
//
//
//  Created by Daniel Martínez on 03/10/2019.
//

import Foundation
import Flutter

public class FContact : Comparable {

    var identifier : String = ""
    var displayName : String = ""
    var contactType : String?
    var namePrefix : String?
    var givenName : String?
    var middleName : String?
    var familyName : String?
    var previousFamilyName : String?
    var nameSuffix : String?
    var nickname : String?
    var phoneticGivenName : String?
    var phoneticMiddleName : String?
    var phoneticFamilyName : String?
    var jobTitle : String?
    var departmentName : String?
    var organizationName : String?
    var phoneticOrganizationName : String?
    var note : String?
    var imageData : Data?
    var thumbnailImageData : Data?
    var imageDataAvailable : Bool = false

    var dates = [FContactDateLabeled]()
    var postalAddresses = [FContactPostalAddressLabeled]()
    var emails = [FContactValueLabeled]()
    var urls = [FContactValueLabeled]()
    var phoneNumbers = [FContactValueLabeled]()
    var socialProfiles = [FContactSocialProfileLabeled]()
    var contactRelations = [FContactValueLabeled]()
    var instantMessageAddresses = [FContactInstantMessageAddressLabeled]()

    public func toMap() -> [String:Any] {
        var result : [String:Any] = [
            "identifier": self.identifier,
            "displayName": self.displayName
        ]
        if let _contactType = self.contactType {
            result[ "contactType" ] = _contactType
        }
        if let _namePrefix = self.namePrefix {
            result[ "namePrefix" ] = _namePrefix
        }
        if let _givenName = self.givenName {
            result[ "givenName" ] = _givenName
        }
        if let _middleName = self.middleName {
            result[ "middleName" ] = _middleName
        }
        if let _familyName = self.familyName {
            result[ "familyName" ] = _familyName
        }
        if let _previousFamilyName = self.previousFamilyName {
            result[ "previousFamilyName" ] = _previousFamilyName
        }
        if let _nameSuffix = self.nameSuffix {
            result[ "nameSuffix" ] = _nameSuffix
        }
        if let _nickname = self.nickname {
            result[ "nickname" ] = _nickname
        }
        if let _phoneticGivenName = self.phoneticGivenName {
            result[ "phoneticGivenName" ] = _phoneticGivenName
        }
        if let _phoneticMiddleName = self.phoneticMiddleName {
            result[ "phoneticMiddleName" ] = _phoneticMiddleName
        }
        if let _phoneticFamilyName = self.phoneticFamilyName {
            result[ "phoneticFamilyName" ] = _phoneticFamilyName
        }
        if let _jobTitle = self.jobTitle {
            result[ "jobTitle" ] = _jobTitle
        }
        if let _departmentName = self.departmentName {
            result[ "departmentName" ] = _departmentName
        }
        if let _organizationName = self.organizationName {
            result[ "organizationName" ] = _organizationName
        }
        if let _phoneticOrganizationName = self.phoneticOrganizationName {
            result[ "phoneticOrganizationName" ] = _phoneticOrganizationName
        }
        if self.dates.count > 0 {
            var _dates = [[String:Any]]()
            for date in self.dates {
                var _components = [String:Any]()
                _components["label"] = date.label as String
                if let _day = date.valueDay {
                    _components["day"] = _day
                }
                if let _month = date.valueMonth {
                    _components["month"] = _month
                }
                if let _year = date.valueYear {
                    _components["year"] = _year
                }
                _dates.append( _components )
            }
            result[ "dates" ] = _dates
        }
        if let _note = self.note {
            result[ "note" ] = _note
        }
        result[ "imageDataAvailable" ] = self.imageDataAvailable
        if let imageData = self.imageData {
            result[ "imageData" ] = FlutterStandardTypedData( bytes: imageData )
        }
        if let thumbnailImageData = self.thumbnailImageData {
            result[ "thumbnailImageData" ] = FlutterStandardTypedData( bytes: thumbnailImageData )
        }
        if self.postalAddresses.count > 0 {
            var _items = [[String:Any]]()
            for postalAddress in self.postalAddresses {
                var _components = [String:String]()
                _components["label"] = postalAddress.label
                if let _street = postalAddress.valueStreet {
                    _components["street"] = _street
                }
                if let _city = postalAddress.valueCity {
                    _components["city"] = _city
                }
                if let _subLocality = postalAddress.valueSubLocality {
                    _components["subLocality"] = _subLocality
                }
                if let _subAdministrativeArea = postalAddress.valueSubAdministrativeArea {
                    _components["subAdministrativeArea"] = _subAdministrativeArea
                }
                if let _postalCode = postalAddress.valuePostalCode {
                    _components["postalCode"] = _postalCode
                }
                if let _state = postalAddress.valueState {
                    _components["state"] = _state
                }
                if let _country = postalAddress.valueCountry {
                    _components["country"] = _country
                }
                if let _isoCountryCode = postalAddress.valueISOCountryCode {
                    _components["isoCountryCode"] = _isoCountryCode
                }
                if let _formatted = postalAddress.formatted {
                    _components["formatted"] = _formatted
                }
                _items.append( _components )
            }
            result[ "postalAddresses" ] = _items
        }
        if self.emails.count > 0 {
            var _items = [[String:Any]]()
            for email in self.emails {
                _items.append([
                    email.label: email.value
                ])
            }
            result[ "emails" ] = _items
        }
        if self.urls.count > 0 {
            var _items = [[String:Any]]()
            for url in self.urls {
                _items.append([
                    url.label: url.value
                ])
            }
            result[ "urls" ] = _items
        }
        if self.phoneNumbers.count > 0 {
            var _items = [[String:Any]]()
            for phoneNumber in self.phoneNumbers {
                _items.append([
                    phoneNumber.label: phoneNumber.value
                ])
            }
            result[ "phoneNumbers" ] = _items
        }
        if self.socialProfiles.count > 0 {
            var _items = [[String:Any]]()
            for socialProfile in self.socialProfiles {
                var _components = [String:String]()
                _components["label"] = socialProfile.label
                if let _service = socialProfile.valueService {
                    _components["service"] = _service
                }
                if let _userIdentifier = socialProfile.valueUserIdentifier {
                    _components["userIdentifier"] = _userIdentifier
                }
                if let _username = socialProfile.valueUsername {
                    _components["username"] = _username
                }
                if let _url = socialProfile.valueUrl {
                    _components["url"] = _url
                }
                _items.append( _components )
            }
            result[ "socialProfiles" ] = _items
        }
        if self.contactRelations.count > 0 {
            var _items = [[String:Any]]()
            for contactRelation in self.contactRelations {
                _items.append([
                    contactRelation.label: contactRelation.value
                ])
            }
            result[ "contactRelations" ] = _items
        }
        if self.instantMessageAddresses.count > 0 {
            var _items = [[String:Any]]()
            for instantMessageAddress in self.instantMessageAddresses {
                var _components = [String:String]()
                _components["label"] = instantMessageAddress.label
                if let _service = instantMessageAddress.valueService {
                    _components["service"] = _service
                }
                if let _username = instantMessageAddress.valueUsername {
                    _components["username"] = _username
                }
                _items.append( _components )
            }
            result[ "instantMessageAddresses" ] = _items
        }

        return result
    }

    public static func == (lhs: FContact, rhs: FContact) -> Bool {
        var returnValue = false
        if (lhs.identifier == rhs.identifier) {
            returnValue = true
        }
        return returnValue
    }

    public static func < (lhs: FContact, rhs: FContact) -> Bool {
        var returnValue = false
        if (lhs.identifier < rhs.identifier) {
            returnValue = true
        }
        return returnValue
    }

}

public class FContactValueLabeled {
    var label: String = ""
    var value: String = ""
}

public class FContactDateLabeled {
    var label: String = ""
    var valueDay: Int?
    var valueMonth: Int?
    var valueYear: Int?
}

public class FContactPostalAddressLabeled {
    var label: String = ""
    var valueStreet: String?
    var valueCity: String?
    var valueSubLocality: String?
    var valueSubAdministrativeArea: String?
    var valuePostalCode: String?
    var valueState: String?
    var valueCountry: String?
    var valueISOCountryCode: String?
    var formatted: String?
}

public class FContactSocialProfileLabeled {
    var label: String = ""
    var valueService: String?
    var valueUserIdentifier: String?
    var valueUsername: String?
    var valueUrl: String?
}

public class FContactInstantMessageAddressLabeled {
    var label: String = ""
    var valueService: String?
    var valueUsername: String?
}
