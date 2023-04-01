import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:renrakusen/contact_list/models/contact_model.dart';
import 'package:sqlite3/sqlite3.dart';

class DB {
  initDB() async {
    // Get the application support directory
    var directory = await getApplicationSupportDirectory();

    // Open a database file located in the application support directory
    var db = sqlite3.open('${directory.path}/dbs');

    createTable();

    // insertIntoContact(
    //     ContactModel(firstName: 'denish', phoneNumber: '8866733212'));
    // // selectSpecificWithId(3);
    // selectNameAndId();
  }

  executeCommand(String? command, String? sql) async {
    // Get the application support directory
    var directory = await getApplicationSupportDirectory();

    // Open a database file located in the application support directory
    var db = sqlite3.open('${directory.path}/dbs');

    if (sql!.isNotEmpty) {
      log("[$command]$sql");
      try {
        db.execute(sql);
      } catch (e) {
        log("[$command] $e");
      }
    }
  }

  createTable() {
    executeCommand("createTable", '''
      CREATE TABLE if not exists contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    photo BLOB,
    firstName TEXT,
    lastName TEXT,
    phoneNumber TEXT,
    email TEXT,
    address TEXT,
    notes TEXT
    )''');
  }

  selectSpecificWithId(int? id) async {
    // Get the application support directory
    var directory = await getApplicationSupportDirectory();

    // Open a database file located in the application support directory
    var db = sqlite3.open('${directory.path}/dbs');

    try {
      final ResultSet resultSet =
          db.select('SELECT * FROM contacts WHERE id=?', ['$id']);
      // You can iterate on the result set in multiple ways to retrieve Row objects
      // one by one.

      return resultSet;
    } catch (e) {
      log("[selectSpecificWithId] $e");
    }
    db.dispose();
  }

  selectNameAndId() async {
    // Get the application support directory
    var directory = await getApplicationSupportDirectory();

    // Open a database file located in the application support directory
    var db = sqlite3.open('${directory.path}/dbs');

    try {
      final ResultSet resultSet =
          db.select('SELECT firstname,lastname,id FROM contacts');
      // You can iterate on the result set in multiple ways to retrieve Row objects
      // one by one.
      return resultSet;
    } catch (e) {
      log("[selectSpecificWithId] $e");
    }
    db.dispose();
  }

  insertIntoContact(ContactModel contactModel) async {
    // Get the application support directory
    var directory = await getApplicationSupportDirectory();

    // Open a database file located in the application support directory
    var db = sqlite3.open('${directory.path}/dbs');

    log('INSERT INTO contacts (photo, firstName, lastName, phoneNumber, email, address, notes) VALUES (?, ?, ?, ?, ?, ?), ${contactModel.firstName.toString()},${contactModel.lastName.toString()},${contactModel.phoneNumber.toString()},${contactModel.email.toString()},${contactModel.address.toString()}, ${contactModel.notes.toString()}',
        name: '[insert]');
    final stmt = db.prepare(
        'INSERT INTO contacts (photo, firstName, lastName, phoneNumber, email, address, notes) VALUES (?, ?, ?, ?, ?, ?, ?)');
    stmt.execute([
      contactModel.photo,
      contactModel.firstName.toString(),
      contactModel.lastName.toString(),
      contactModel.phoneNumber.toString(),
      contactModel.email.toString(),
      contactModel.address.toString(),
      contactModel.notes.toString()
    ]);
  }

  deleteFromContact(int id) async {
    var directory = await getApplicationSupportDirectory();

    // Open a database file located in the application support directory
    var db = sqlite3.open('${directory.path}/dbs');

    log('DELETE FROM contacts WHERE id = $id', name: '[delete]');
    final stmt = db.prepare('DELETE FROM contacts  WHERE id = ?');
    stmt.execute([id]);
  }

  editContact(ContactModel cm) async {
    var directory = await getApplicationSupportDirectory();

    // Open a database file located in the application support directory
    var db = sqlite3.open('${directory.path}/dbs');

    log('UPDATE contacts SET firstName = ${cm.firstName}, lastName = ${cm.lastName}, phoneNumber = ${cm.phoneNumber}, email = ${cm.email}, address = ${cm.address}, notes = ${cm.notes} WHERE id = ${cm.id}',
        name: '[edit]');
    final stmt = db.prepare(
        'UPDATE contacts SET firstName = ?, lastName = ?, phoneNumber = ?, email = ?, address = ?, notes = ? WHERE id = ?');
    stmt.execute([
      cm.firstName,
      cm.lastName,
      cm.phoneNumber,
      cm.email,
      cm.address,
      cm.notes,
      cm.id,
    ]);
  }
}
