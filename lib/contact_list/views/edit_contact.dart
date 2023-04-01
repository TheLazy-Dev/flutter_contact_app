import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:renrakusen/contact_list/controller/contact_controller.dart';
import 'package:renrakusen/contact_list/models/contact_model.dart';
import 'package:renrakusen/contact_list/views/add_contact.dart';
import 'package:renrakusen/contact_list/views/view_contact_by_id.dart';

void showEditContactSheet(BuildContext context, ContactModel contact) {
  final TextEditingController fnameController =
      TextEditingController(text: contact.firstName);
  final TextEditingController lnameController =
      TextEditingController(text: contact.lastName);
  final TextEditingController notesController =
      TextEditingController(text: contact.notes);
  final TextEditingController phoneController =
      TextEditingController(text: contact.phoneNumber);
  final TextEditingController emailController =
      TextEditingController(text: contact.email);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          bool isSavingAllowed = fnameController.value.text.isNotEmpty;

          return Consumer<ContactTableController>(
            builder: (_, value, __) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    sizedBox10Sp,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontSize: 16.sp),
                            )),
                        sizedBox20Sp,
                        Text(
                          "Edit Contact",
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        sizedBox20Sp,
                        TextButton(
                            onPressed: () {
                              value.editContact(ContactModel(
                                  id: contact.id,
                                  firstName: fnameController.text,
                                  lastName: lnameController.text,
                                  email: emailController.text,
                                  phoneNumber: phoneController.text));
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: (isSavingAllowed)
                                      ? Colors.blue
                                      : Colors.grey),
                            )),
                      ],
                    ),
                    sizedBox10Sp,
                    CircleAvatar(
                      radius: 60.sp,
                    ),
                    sizedBox10Sp,
                    TextFieldAndController(
                      editingController: fnameController,
                      label: 'First Name',
                    ),
                    sizedBox10Sp,
                    TextFieldAndController(
                        editingController: lnameController, label: 'Last Name'),
                    sizedBox10Sp,
                    TextFieldAndController(
                        editingController: phoneController, label: 'Phone'),
                    sizedBox10Sp,
                    TextFieldAndController(
                        editingController: emailController, label: 'Email'),
                    sizedBox10Sp,
                  ],
                ),
              );
            },
          );
        },
      ),
    ),
  );
}
