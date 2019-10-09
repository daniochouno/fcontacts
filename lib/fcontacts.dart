import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FContacts {

  static const MethodChannel _channel =
      const MethodChannel('fcontacts');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<List<FContact>> all() async {
    Iterable all = await _channel.invokeMethod( "list" );
    var mapped = all.map( (item) => FContact.fromMap(item) );
    return mapped.toList();
  }

  static Future<List<FContact>> list({ query: String }) async {
    Iterable filtered = await _channel.invokeMethod( "list", <String,dynamic>{
      'query': query
    } );
    var mapped = filtered.map( (item) => FContact.fromMap(item) );
    return mapped.toList();
  }

}

class FContact {

  FContact({
    this.identifier,
    this.displayName
  });

  String identifier;
  String displayName;
  String contactType;
  String namePrefix;
  String givenName;
  String middleName;
  String familyName;
  String previousFamilyName;  // Only iOS
  String nameSuffix;
  String nickname;
  String phoneticGivenName;   // Only iOS
  String phoneticMiddleName;  // Only iOS
  String phoneticFamilyName;  // Only iOS
  String jobTitle;
  String departmentName;      // Only iOS
  String organizationName;
  String phoneticOrganizationName;  // Only iOS
  int birthdayDay;
  int birthdayMonth;
  int birthdayYear;
  String note;        // Only Android
  Uint8List image;
  Uint8List thumbnail;

  List<FContactDateLabeled> dates = List<FContactDateLabeled>();
  List<FContactPostalAddressLabeled> postalAddresses = List<FContactPostalAddressLabeled>();
  List<FContactValueLabeled> emails = List<FContactValueLabeled>();
  List<FContactValueLabeled> urls = List<FContactValueLabeled>();
  List<FContactValueLabeled> phoneNumbers = List<FContactValueLabeled>();
  List<FContactSocialProfileLabeled> socialProfiles = List<FContactSocialProfileLabeled>();   // Only iOS
  List<FContactValueLabeled> contactRelations = List<FContactValueLabeled>();
  List<FContactInstantMessageAddressLabeled> instantMessageAddresses = List<FContactInstantMessageAddressLabeled>();

  FContact.fromMap( Map map ) {
    identifier = map["identifier"];
    displayName = map["displayName"];
    contactType = map["contactType"];
    namePrefix = map["namePrefix"] ?? null;
    givenName = map["givenName"] ?? null;
    middleName = map["middleName"] ?? null;
    familyName = map["familyName"] ?? null;
    previousFamilyName = map["previousFamilyName"] ?? null;
    nameSuffix = map["nameSuffix"] ?? null;
    nickname = map["nickname"] ?? null;
    phoneticGivenName = map["phoneticGivenName"] ?? null;
    phoneticMiddleName = map["phoneticMiddleName"] ?? null;
    phoneticFamilyName = map["phoneticFamilyName"] ?? null;
    jobTitle = map["jobTitle"] ?? null;
    departmentName = map["departmentName"] ?? null;
    organizationName = map["organizationName"] ?? null;
    phoneticOrganizationName = map["phoneticOrganizationName"] ?? null;
    birthdayDay = map["birthdayDay"] ?? null;
    birthdayMonth = map["birthdayMonth"] ?? null;
    birthdayYear = map["birthdayYear"] ?? null;
    note = map["note"] ?? null;
    image = map["imageData"] ?? null;
    thumbnail = map["thumbnailData"] ?? null;
    dates = (map["dates"] as Iterable)?.map( (item) => FContactDateLabeled.fromMap( item ) )?.toList();
    emails = (map["emails"] as Iterable)?.map( (item) => FContactValueLabeled.fromMap( item ) )?.toList();
    urls = (map["urls"] as Iterable)?.map( (item) => FContactValueLabeled.fromMap( item ) )?.toList();
    postalAddresses = (map["postalAddresses"] as Iterable)?.map( (item) => FContactPostalAddressLabeled.fromMap( item ) )?.toList();
    phoneNumbers = (map["phoneNumbers"] as Iterable)?.map( (item) => FContactValueLabeled.fromMap( item ) )?.toList();
    contactRelations = (map["contactRelations"] as Iterable)?.map( (item) => FContactValueLabeled.fromMap( item ) )?.toList();
    socialProfiles = (map["socialProfiles"] as Iterable)?.map( (item) => FContactSocialProfileLabeled.fromMap( item ) )?.toList();
    instantMessageAddresses = (map["instantMessageAddresses"] as Iterable)?.map( (item) => FContactInstantMessageAddressLabeled.fromMap( item ) )?.toList();
  }

}

class FContactValueLabeled {
  String label;
  String value;
  FContactValueLabeled({ this.label, this.value });
  static FContactValueLabeled fromMap( Map map ) {
    return FContactValueLabeled( label: map.keys.first as String, value: map.values.first as String );
  }
}

class FContactDateLabeled {
  String label;
  int day;
  int month;
  int year;
  FContactDateLabeled({ this.label, this.day, this.month, this.year });
  static FContactDateLabeled fromMap( Map map ) {
    return FContactDateLabeled(
        label: map["label"] as String,
        day: map["day"] as int,
        month: map["month"] as int,
        year: map["year"] as int
    );
  }
}

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
  FContactPostalAddressLabeled({ this.label, this.street, this.city, this.subLocality, this.subAdministrativeArea, this.postalCode, this.state, this.country, this.isoCountryCode, this.formatted });
  static FContactPostalAddressLabeled fromMap( Map map ) {
    return FContactPostalAddressLabeled(
        label: map["label"] as String,
        street: map["street"] as String,
        city: map["city"] as String,
        subLocality: map["subLocality"] as String,
        subAdministrativeArea: map["subAdministrativeArea"] as String,
        postalCode: map["postalCode"] as String,
        state: map["state"] as String,
        country: map["country"] as String,
        isoCountryCode: map["isoCountryCode"] as String,
        formatted: map["formatted"] as String
    );
  }
}

class FContactSocialProfileLabeled {
  String label;
  String service;
  String userIdentifier;
  String username;
  String url;
  FContactSocialProfileLabeled({ this.label, this.service, this.userIdentifier, this.username, this.url });
  static FContactSocialProfileLabeled fromMap( Map map ) {
    return FContactSocialProfileLabeled(
        label: map["label"] as String,
        service: map["service"] as String,
        userIdentifier: map["userIdentifier"] as String,
        username: map["username"] as String,
        url: map["url"] as String
    );
  }
}

class FContactInstantMessageAddressLabeled {
  String label;
  String service;
  String username;
  FContactInstantMessageAddressLabeled({ this.label, this.service, this.username });
  static FContactInstantMessageAddressLabeled fromMap( Map map ) {
    return FContactInstantMessageAddressLabeled(
        label: map["label"] as String,
        service: map["service"] as String,
        username: map["username"] as String
    );
  }
}
