# fcontacts_example

This is a code example on how to use this plugin. You can check the files used in our repository.

## main.dart

```dart
import 'package:flutter/material.dart';
import 'dart:async';

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
                            subtitle: Text( item.identifier )
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

```

## Credits

This plugin has been created and developed by [Daniel Martínez](mailto:dmartinez@danielmartinez.info).

Any suggestions and contributions are welcomed.
Thanks for using this plugin!
