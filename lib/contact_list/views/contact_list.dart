import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:renrakusen/contact_list/controller/contact_controller.dart';
import 'package:renrakusen/contact_list/views/add_contact.dart';
import 'package:renrakusen/contact_list/views/view_contact_by_id.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final contactProvider =
        Provider.of<ContactTableController>(context, listen: false);
    contactProvider.fetchAllContacts();
    return Scaffold(
      body: Consumer<ContactTableController>(builder: (context, value, __) {
        return value.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : value.contacts.isEmpty
                ? const Center(
                    child: Text("Add A Contact"),
                  )
                : ListView.builder(
                    itemCount:
                        value.contacts.length, // Number of items in the list
                    itemBuilder: (BuildContext context, int index) {
                      return SlidingListTile(
                        id: value.contacts[index].id,
                        firstName: value.contacts[index].firstName,
                        lastName: value.contacts[index].lastName == 'null'
                            ? ''
                            : value.contacts[index].lastName,
                      );
                    },
                  );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddContactSheet(context),
        //backgroundColor: Color(0xff5234fd),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SlidingListTile extends StatelessWidget {
  const SlidingListTile(
      {super.key, this.firstName, this.lastName, required this.id});

  final String? firstName, lastName;
  final int id;

  @override
  Widget build(BuildContext context) {
    final contactProvider =
        Provider.of<ContactTableController>(context, listen: false);
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        openThreshold: 0.1,

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) => showContactBottomSheet(context, id),
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.info,
            label: 'info',
          ),
        ],
      ),
      // The start action pane is the one at the left or the top side.
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () {
          contactProvider.delteFromDbWithId(id);
        }),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.

          SlidableAction(
            onPressed: (context) => contactProvider.delteFromDbWithId(id),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: InkWell(
        onTap: () => showContactBottomSheet(context, id),
        child: ListTile(
          leading: CircleAvatar(
            child: Center(
              child: Text(firstName!.substring(0, 1)),
            ),
          ),
          title: Text(
            "$firstName $lastName",
            style: GoogleFonts.poppins(
                fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
