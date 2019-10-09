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

```dart
List<FContact> allContacts = await FContacts.all();
```

### FContact model

```dart
class FContact {
    String identifier;
    String displayName;
    String contactType;
    String namePrefix;
    String givenName;
    String middleName;
    String familyName;
    String previousFamilyName;
    String nameSuffix;
    String nickname;
    String phoneticGivenName;
    String phoneticMiddleName;
    String phoneticFamilyName;
    String jobTitle;
    String departmentName;
    String organizationName;
    String phoneticOrganizationName;
    int birthdayDay;
    int birthdayMonth;
    int birthdayYear;
    String note;
    Uint8List image;
    Uint8List thumbnail;

    List<FContactDateLabeled> dates = List<FContactDateLabeled>();
    List<FContactPostalAddressLabeled> postalAddresses = List<FContactPostalAddressLabeled>();
    List<FContactValueLabeled> emails = List<FContactValueLabeled>();
    List<FContactValueLabeled> urls = List<FContactValueLabeled>();
    List<FContactValueLabeled> phoneNumbers = List<FContactValueLabeled>();
    List<FContactSocialProfileLabeled> socialProfiles = List<FContactSocialProfileLabeled>();
    List<FContactValueLabeled> contactRelations = List<FContactValueLabeled>();
    List<FContactInstantMessageAddressLabeled> instantMessageAddresses = List<FContactInstantMessageAddressLabeled>();

}
```

### FContactDateLabeled


## Limitations

- Only retrieving the list of all contacts is available for now. In future query methods will be available, too.
- The **Notes** field in iOS is not available for now.

## Credits

This plugin has been created and developed by [Daniel Martinez](mailto:dmartinez@danielmartinez.info).

Any suggestions and contributions are welcomed.
Thanks for using this plugin!