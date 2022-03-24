import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';




import 'package:flutter_sms/flutter_sms.dart';

import 'home_screen.dart';

void main() => runApp(ContactHome());

class ContactHome extends StatelessWidget {
  const ContactHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late var _suggestions = <Contact>[];
  final List<Contact> _saved = [];
  List<Contact> contactsFiltered = [];
  List<String> phoneNumberList = [];
  List<String> phoneNumUnique = [];
  TextEditingController searchController = new TextEditingController();

  List<Contact> _contacts = [];





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact();
    searchController.addListener(() {
      filterContacts();
    });
  }

  filterContacts(){
    List<Contact> _allContact = [];
    _allContact.addAll(_suggestions);

    if(searchController.text.isNotEmpty){
      _allContact.retainWhere((contact) {
      String searchName = searchController.text.toLowerCase();
      String contactName = contact.displayName.toLowerCase();
      return contactName.contains(searchName);
    });
      setState(() {
        contactsFiltered = _allContact;
      });
    }
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
     List<Contact> _contacts = await FlutterContacts.getContacts(withProperties: true);
      //  print(contacts);
      setState(() {
        _suggestions = _contacts;
      });
    }
  }
  void getPhoneNumber() {
    int i;
    for (i = 0; i < _saved.length; i++) {
     String phone = _saved[i].phones.first.normalizedNumber;
     phoneNumberList.add(phone);
//     List<String> phoneNumUnique = phoneNumberList.toSet().toList();
//     phoneNumberList = phoneNumUnique;
    }
    print(phoneNumberList);
  //  var json = jsonEncode(phoneNumberList.map((e) => e.toJson()).toList());
  }
  /// get the list <string> in the sendSMS function and trim the list before sending to the recipents list
  /// List<String> phoneNumUnique = phoneNumberList.toSet().toList(); - use this logic

  void _sendSMS(String message, List<String> recipents) async {
    List<String> phoneNumUnique = recipents.toSet().toList();
    print(phoneNumUnique);
    String _result = await sendSMS(message: message, recipients: phoneNumUnique)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  _getPermission() async => await [
    Permission.sms,
  ].request();

  Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  _sendMessage(String phoneNumber, String message, {int? simSlot}) async {
    var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: simSlot);
    if (result == SmsStatus.sent) {
      print("Sent");
    } else {
      print("Failed");
    }
  }
  Future<bool?> get _supportCustomSim async =>
      await BackgroundSms.isSupportCustomSim;



  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( icon: Icon(
          Icons.list,
        ),
          onPressed: () {},
        ),
        title: const Text(
          "AlwarTeam.Com",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(width: 1000, height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _saved.length < 1
                      ? "SELECT ALWAR TEAM MEMBERS"
                      : "${_saved.length} Members Selected",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: Text("SEND SMS TO SELETED CONTACTS"),
                      onPressed: () {
                          _sendSMS("Custom Message", phoneNumberList); }

                      ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      child: Text("Upload Contacts"),
                      onPressed: () {
                      //  uploadContacts();
                      }),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    child: Text("Skip to Main Content"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      }),
                  ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: (_suggestions) == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: isSearching ? contactsFiltered.length : _suggestions.length,
                      itemBuilder: (BuildContext context, int index) {
                        Contact contact = isSearching ? contactsFiltered[index] : _suggestions[index];
                        Uint8List? image = contact.photo;
                        String num = (contact.phones.isNotEmpty)
                            ? (contact
                                .phones
                                .first
                                .normalizedNumber)
                            : "--";

                        final alreadySaved =
                            _saved.contains(contact);
                        // Contact savedContact = _saved[index];

                        return ListTile(
                            leading: (contact.photo == null)
                                ? const CircleAvatar(child: Icon(Icons.person))
                                : CircleAvatar(
                                    backgroundImage: MemoryImage(image!)),
                            title: Text(contact.displayName),
                            //       "${_suggestions[index].name.first} ${_suggestions[index].name.last}"

                            subtitle: Text(num),
                            trailing: Icon(
                              alreadySaved
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: alreadySaved ? Colors.green : null,
                              semanticLabel:
                                  alreadySaved ? 'Remove from saved' : 'Save',
                            ),
                            onTap: () {
                              setState(() {
                                if (alreadySaved) {
                                  _saved.remove(contact);
                                } else {
                                  _saved.add(contact);
                                }
                                getPhoneNumber();
                              });
                            });
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
