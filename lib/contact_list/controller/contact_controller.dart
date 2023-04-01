import 'package:flutter/material.dart';
import 'package:renrakusen/contact_list/models/contact_model.dart';
import 'package:renrakusen/utils/db/db_main.dart';
import 'package:sqlite3/sqlite3.dart';

class ContactTableController extends ChangeNotifier {
  bool isLoading = false;
  final DB _db = DB();

  List contacts = [];
  ContactModel singleContact = ContactModel();

  String firstName = ''; // only for new Contact Image handler

  saveContactToDB(ContactModel cm) async {
    isLoading = true;
    await _db.insertIntoContact(cm);
    isLoading = false;

    fetchAllContacts();

    notifyListeners();
  }

  fetchContactWithId(int? id) async {
    isLoading = true;
    ResultSet fetchedContact = (await _db.selectSpecificWithId(id));
    singleContact = ContactModel.fromJson((fetchedContact.first));
    isLoading = false;

    notifyListeners();
  }

  fetchAllContacts() async {
    isLoading = true;
    contacts.clear();
    var fetchedContacts = await _db.selectNameAndId();
    if (fetchedContacts != null) {
      for (var contact in fetchedContacts) {
        contacts.add(ContactModel.fromJson(contact));
      }
    }
    isLoading = false;

    notifyListeners();
  }

  delteFromDbWithId(int id) async {
    _db.deleteFromContact(id);
    fetchAllContacts();

    notifyListeners();
  }

  editContact(ContactModel cm) async {
    _db.editContact(cm);
    fetchAllContacts();
    fetchContactWithId(cm.id);

    notifyListeners();
  }
}
