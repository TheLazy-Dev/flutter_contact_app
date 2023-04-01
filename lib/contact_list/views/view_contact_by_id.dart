import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:renrakusen/contact_list/controller/contact_controller.dart';
import 'package:renrakusen/contact_list/models/contact_model.dart';
import 'package:renrakusen/contact_list/views/edit_contact.dart';
import 'package:url_launcher/url_launcher.dart';

void showContactBottomSheet(BuildContext context, int id) {
  int contactId = id;
  showModalBottomSheet(
    context: context,
    enableDrag: true,
    useSafeArea: true,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: true,
    elevation: 10,
    barrierColor: const Color.fromARGB(101, 12, 37, 178),
    shape: Border.all(color: Colors.blueAccent),
    builder: (context) => ShowContact(id: contactId),
  );
}

class ShowContact extends StatelessWidget {
  const ShowContact({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final contactProvider =
        Provider.of<ContactTableController>(context, listen: false);
    contactProvider.fetchContactWithId(id);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                showEditContactSheet(context, contactProvider.singleContact);
              },
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 16.sp,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5.sp,
                    ),
                    Text("Edit",
                        style: TextStyle(color: Colors.black, fontSize: 18.sp)),
                  ]),
            ),
          )
        ],
        centerTitle: false,
        automaticallyImplyLeading: true,
        leadingWidth: 120.sp,
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                )),
            Text(
              "Contacts",
              style: TextStyle(color: Colors.black, fontSize: 16.sp),
            )
          ],
        ),
      ),
      body: Consumer<ContactTableController>(builder: (_, value, __) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Header(character: value.singleContact.firstName?.substring(0, 1)),
              sizedBox20Sp,
              Text(
                "${value.singleContact.firstName} ${value.singleContact.lastName == 'null' ? '' : value.singleContact.lastName}",
                style: GoogleFonts.poppins(fontSize: 20.sp),
              ),
              sizedBox20Sp,
              ButtonRow(value: value.singleContact),
              sizedBox20Sp,
              PhoneEmailInfoContainer(
                value: value.singleContact,
              ),
              sizedBox20Sp,
              const NotesHandler(),
              sizedBox20Sp,
              ButtonContainerColumn(id: value.singleContact.id ?? 0),
            ],
          ),
        );
      }),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key, this.character});

  final String? character;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 40.sp,
        child: Text(
          "$character".toUpperCase(),
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key, required this.value});

  final value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonRowButton(
          iconData: Icons.message,
          text: 'Message',
          available: value.phoneNumber != 'null',
          onTap: () {
            print(0);
            launchUrl(Uri.parse('sms:${value.phoneNumber}'));
          },
        ),
        ButtonRowButton(
          iconData: Icons.call,
          text: 'Call',
          available: value.phoneNumber != 'null',
          onTap: () {
            launchUrl(Uri.parse("tel://${value.phoneNumber}"));
          },
        ),
        const ButtonRowButton(
          iconData: Icons.video_call,
          available: false,
          text: 'Video Call',
        ),
        ButtonRowButton(
          iconData: Icons.mail,
          available: !(value.email == 'null' ||
              value.email.toString().isEmpty ||
              value.email == null ||
              value.email == ""),
          text: 'Mail',
        ),
      ],
    );
  }
}

class ButtonRowButton extends StatelessWidget {
  const ButtonRowButton(
      {super.key, this.iconData, this.text, this.onTap, this.available});

  final IconData? iconData;
  final String? text;
  final VoidCallback? onTap;
  final bool? available;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (available ?? true) ? onTap : null,
      child: Container(
        width: 75.sp,
        height: 50.sp,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 1,
                color: (available ?? true) ? Colors.black : Colors.grey),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(iconData,
                color: (available ?? true) ? Colors.black : Colors.grey),
            Text(
              "$text",
              style: TextStyle(
                  color: (available ?? true) ? Colors.black : Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

class PhoneEmailInfoContainer extends StatelessWidget {
  const PhoneEmailInfoContainer({super.key, required this.value});

  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InfoContainer(
            infoName: 'Phone',
            info: value.phoneNumber,
            onTap: () {
              launchUrl(Uri.parse('tel://${value.phoneNumber}'));
            },
          ),
          SizedBox(height: 15.sp),
          InfoContainer(
            info: value.email,
            infoName: 'Email',
          )
        ],
      ),
    );
  }
}

class InfoContainer extends StatelessWidget {
  const InfoContainer({super.key, this.infoName, this.info, this.onTap});

  final String? infoName;
  final String? info;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !(info == 'null' ||
          info.toString().isEmpty ||
          info == null ||
          info == ""),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: ScreenUtil().screenWidth - 10,
          height: 60.sp,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(blurRadius: 1, spreadRadius: 1, color: Colors.grey)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "$infoName",
                  style: TextStyle(fontSize: 16.sp),
                ),
                Text(
                  "$info",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotesHandler extends StatelessWidget {
  const NotesHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0.sp,
      ),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
          hintText: 'Add Notes',
        ),
      ),
    );
  }
}

class ButtonContainerColumn extends StatelessWidget {
  const ButtonContainerColumn({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    var contactProvider =
        Provider.of<ContactTableController>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ButtonContainer(
          onTap: () {
            contactProvider.delteFromDbWithId(id);
            Navigator.pop(context);
          },
          buttonName: 'Delete This Contact',
          color: Colors.red.shade400,
        )
      ],
    );
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({super.key, this.buttonName, this.onTap, this.color});

  final String? buttonName;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: ScreenUtil().screenWidth - 10,
          height: 50.sp,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(blurRadius: 1, spreadRadius: 1, color: Colors.grey)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "$buttonName",
                  style:
                      TextStyle(fontSize: 16.sp, color: color ?? Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget sizedBox20Sp = SizedBox(
  height: 10.sp,
);
