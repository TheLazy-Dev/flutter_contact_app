import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:renrakusen/contact_list/controller/contact_controller.dart';
import 'package:renrakusen/contact_list/models/contact_model.dart';
import 'package:renrakusen/contact_list/views/view_contact_by_id.dart';

void showAddContactSheet(BuildContext context) {
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
      child: const AddContactSheet(),
    ),
  );
}

class AddContactSheet extends StatefulWidget {
  const AddContactSheet({Key? key}) : super(key: key);

  @override
  State<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isSavingAllowed = false;

  @override
  void initState() {
    super.initState();
    fnameController.addListener(onChanged);
  }

  @override
  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    notesController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void onChanged() {
    setState(() {
      isSavingAllowed = fnameController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactTableController>(builder: (_, value, __) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
                const Text(
                  'New Contact',
                  style: TextStyle(fontSize: 18.0),
                ),
                TextButton(
                  onPressed: isSavingAllowed
                      ? () {
                          value.saveContactToDB(
                            ContactModel(
                              firstName: fnameController.text,
                              lastName: lnameController.text,
                              email: emailController.text,
                              phoneNumber: phoneController.text,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Done'),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            CircleAvatar(
              radius: 60.sp,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFieldAndController(
              editingController: fnameController,
              label: 'First Name',
              inputType: TextInputType.name,
            ),
            sizedBox10Sp,
            TextFieldAndController(
              editingController: lnameController,
              label: 'Last Name',
              inputType: TextInputType.name,
            ),
            sizedBox10Sp,
            TextFieldAndController(
              editingController: phoneController,
              label: 'Phone',
              inputType: TextInputType.phone,
            ),
            sizedBox10Sp,
            TextFieldAndController(
              editingController: emailController,
              label: 'Email',
              inputType: TextInputType.emailAddress,
            ),
          ],
        ),
      );
    });
  }
}

class TextFieldAndController extends StatelessWidget {
  const TextFieldAndController({
    Key? key,
    required this.editingController,
    required this.label,
    this.inputType,
  }) : super(key: key);

  final TextEditingController editingController;
  final String label;
  final TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: editingController,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(),
          ),
        ),
      ),
    );
  }
}

Widget sizedBox10Sp = SizedBox(
  height: 10.sp,
);
