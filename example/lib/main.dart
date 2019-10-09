import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:fcontacts/fcontacts.dart';

void main() => runApp(FContactsApp());

class FContactsApp extends StatefulWidget {
  @override
  _FContactsAppState createState() => _FContactsAppState();
}

class _FContactsAppState extends State<FContactsApp> {

  TextEditingController searchController = TextEditingController();

  List<FContact> all = List();
  List<FContact> filtered = List();

  @override
  void initState() {
    super.initState();
    _loadContacts().then( (_list) {
      setState(() {
        this.all = _list;
        this.filtered = _list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Contacts (${this.filtered.length})'),
        ),
        body: Container(
          child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all( 8.0 ),
                    child: TextField(
                      onChanged: (text) {
                        filter(text);
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Type to search...",
                        prefixIcon: Icon(Icons.search)
                      ),
                    )
                ),
                Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: this.filtered.length,
                        itemBuilder: (BuildContext context, int index) {
                          final FContact item = this.filtered[index];
                          return ListTile(
                            title: Text( item.displayName ),
                            subtitle: Text( item.identifier ),
                            onTap: () {
                              Navigator.push( context, MaterialPageRoute( builder: (context) => ContactDetailsPage( contact: item ) ) );
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        }
                    )
                )
              ]
          )
        ),
      ),
    );
  }

  Future<List<FContact>> _loadContacts() async {
    return await FContacts.all();
  }

  void filter( String query ) async {
    if (query.isNotEmpty) {
      List<FContact> _filtered = await FContacts.list( query: query );
      setState(() {
        this.filtered = _filtered;
      });
    } else {
      setState(() {
        this.filtered = this.all;
      });
    }
  }

}

class ContactDetailsPage extends StatelessWidget {

  final FContact contact;

  ContactDetailsPage({ this.contact });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text( this.contact.displayName )
      ),
      body: Padding(
        padding: EdgeInsets.all( 16.0 ),
        child: ListView(
          children: <Widget>[
            _image( "Thumbnail:", this.contact.thumbnail ),
            _image( "Image:", this.contact.image ),
            _field( "Identifier:", this.contact.identifier ),
            _field( "Display Name:", this.contact.displayName ),
            _field( "Type:", this.contact.contactType ),
            _field( "Name Prefix:", this.contact.namePrefix ),
            _field( "Given Name:", this.contact.givenName ),
            _field( "Middle Name:", this.contact.middleName ),
            _field( "Family Name:", this.contact.familyName ),
            _field( "Previous Family Name:", this.contact.previousFamilyName ),
            _field( "Name Suffix:", this.contact.nameSuffix ),
            _field( "Nickname:", this.contact.nickname ),
            _field( "Phonetic Given Name:", this.contact.phoneticGivenName ),
            _field( "Phonetic Middle Name:", this.contact.phoneticMiddleName ),
            _field( "Phonetic Family Name:", this.contact.phoneticFamilyName ),
            _field( "Job Title:", this.contact.jobTitle ),
            _field( "Department Name:", this.contact.departmentName ),
            _field( "Organization Name:", this.contact.organizationName ),
            _field( "Phonetic Organization Name:", this.contact.phoneticOrganizationName ),
            _field( "Birthday day:", ((this.contact.birthdayDay != null) ? "${this.contact.birthdayDay}" : null) ),
            _field( "Birthday month:", ((this.contact.birthdayMonth != null) ? "${this.contact.birthdayMonth}" : null) ),
            _field( "Birthday year:", ((this.contact.birthdayYear != null) ? "${this.contact.birthdayYear}" : null) ),
            _field( "Note:", this.contact.note ),
            _listDates( "Dates:", this.contact.dates ),
            _listPostalAddresses( "Postal Addresses:", this.contact.postalAddresses ),
            _list( "Emails:", this.contact.emails ),
            _list( "Urls:", this.contact.urls ),
            _list( "Phone Numbers:", this.contact.phoneNumbers ),
            _listSocialProfiles( "Social Profiles:", this.contact.socialProfiles ),
            _list( "Contact Relations:", this.contact.contactRelations ),
            _listInstantMessageAddresses( "Instant Message Addresses:", this.contact.instantMessageAddresses ),
          ],
        ),
      ),
    );
  }

  Widget _list( String title, List<FContactValueLabeled> items ) {
    if ((items != null) && (items.isNotEmpty)) {
      return _row(
        title,
        ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];
              return Text(
                  "${item.label} :  ${item.value}",
                  textAlign: TextAlign.center
              );
            }
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _listDates( String title, List<FContactDateLabeled> items ) {
    if ((items != null) && (items.isNotEmpty)) {
      return _row(
        title,
        ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];
              String formatted = "";
              if (item.day != null) {
                formatted += "${item.day}";
              }
              if (item.month != null) {
                formatted += "-${item.month}";
              }
              if (item.year != null) {
                formatted += "-${item.year}";
              }
              return Text(
                  "${item.label} :  $formatted",
                  textAlign: TextAlign.center
              );
            }
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _listPostalAddresses( String title, List<FContactPostalAddressLabeled> items ) {
    if ((items != null) && (items.isNotEmpty)) {
      return _row(
        title,
        ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];
              return Text(
                  "${item.label} :  ${item.formatted}",
                  textAlign: TextAlign.center
              );
            }
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _listSocialProfiles( String title, List<FContactSocialProfileLabeled> items ) {
    if ((items != null) && (items.isNotEmpty)) {
      return _row(
        title,
        ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];
              return Text(
                  "${item.label} :  ${item.service}, ${item.userIdentifier}, ${item.username}, ${item.url}",
                  textAlign: TextAlign.center
              );
            }
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _listInstantMessageAddresses( String title, List<FContactInstantMessageAddressLabeled> items ) {
    if ((items != null) && (items.isNotEmpty)) {
      return _row(
        title,
        ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];
              return Text(
                  "${item.label} :  ${item.service}, ${item.username}",
                  textAlign: TextAlign.center
              );
            }
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _image( String title, Uint8List image ) {
    if (image != null) {
      return _row(
          title,
          CircleAvatar(
              backgroundImage: MemoryImage(image)
          )
      );
    } else {
      return Container();
    }
  }

  Widget _field( String title, String value ) {
    if (value != null) {
      return _row(
          title,
          Text(
              value,
              textAlign: TextAlign.end
          )
      );
    } else {
      return Container();
    }
  }

  Widget _row( String title, Widget value ) {
    return Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: value,
            )
          ],
        )
    );
  }

}
