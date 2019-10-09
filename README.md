# fcontacts

[![pub package](https://img.shields.io/pub/v/fcontacts.svg)](https://pub.dartlang.org/packages/fcontacts)

A Flutter plugin for accessing to all available data from your phone contacts. Supports iOS and Android.

## Getting Started

In Android, you need to add the **READ_CONTACTS** permission in your AndroidManifest.xml.  

```xml
<uses-permission android:name="android.permission.READ_CONTACTS" />
```

In iOS, you need to add the key **NSContactsUsageDescription** in your Info.plist file.

```xml
<key>NSContactsUsageDescription</key>
<string>We need access to your contacts for this demo</string>
````

## Usage

### Import package

To use this plugin you must add `fcontacts` as a [dependency in your `pubspec.yaml` file](https://flutter.io/platform-plugins/).

```yaml
dependencies:
    fcontacts: ^0.0.1
```

### Example

```dart
import 'package:fcontacts/fcontacts.dart';
````

Listing all the contacts in your device:

```dart
List<FContact> allContacts = await FContacts.all();
```

### Models

#### FContact

```dart
class FContact {
    String identifier;
    String displayName;
    String contactType;
    String namePrefix;
    String givenName;
    String middleName;
    String familyName;
    String previousFamilyName;              // Only in iOS
    String nameSuffix;
    String nickname;
    String phoneticGivenName;               // Only in iOS
    String phoneticMiddleName;              // Only in iOS
    String phoneticFamilyName;              // Only in iOS
    String jobTitle;
    String departmentName;                  // Only in iOS
    String organizationName;
    String phoneticOrganizationName;        // Only in iOS
    int birthdayDay;
    int birthdayMonth;
    int birthdayYear;
    String note;                            // Only in Android
    Uint8List image;
    Uint8List thumbnail;
    
    List<FContactDateLabeled> dates;
    List<FContactPostalAddressLabeled> postalAddresses;
    List<FContactValueLabeled> emails;
    List<FContactValueLabeled> urls;
    List<FContactValueLabeled> phoneNumbers;
    List<FContactSocialProfileLabeled> socialProfiles;                      // Only in iOS
    List<FContactValueLabeled> contactRelations;
    List<FContactInstantMessageAddressLabeled> instantMessageAddresses;
    
}
```

#### FContactValueLabeled

```dart
class FContactValueLabeled {
    String label;
    String value;
}
````

#### FContactDateLabeled

```dart
class FContactDateLabeled {
    String label;
    int day;
    int month;
    int year;
}
````

#### FContactPostalAddressLabeled

```dart
class FContactPostalAddressLabeled {
    String label;
    String street;
    String city;
    String subLocality;
    String subAdministrativeArea;
    String postalCode;
    String state;
    String country;
    String isoCountryCode;
    String formatted;
}
````

#### FContactSocialProfileLabeled

```dart
class FContactSocialProfileLabeled {
    String label;
    String service;
    String userIdentifier;
    String username;
    String url;
}
````

#### FContactInstantMessageAddressLabeled

```dart
class FContactInstantMessageAddressLabeled {
    String label;
    String service;
    String username;
}
````


## Limitations

- Only retrieving the list of all contacts is available for now. In future query methods will be available, too.
- The **Notes** field in iOS is not available for now.

## Credits

This plugin has been created and developed by [Daniel Martínez](mailto:dmartinez@danielmartinez.info).

Any suggestions and contributions are welcomed.
Thanks for using this plugin!
