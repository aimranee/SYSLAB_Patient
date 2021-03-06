import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syslab_admin/service/admin_service.dart';
import 'package:syslab_admin/service/appointment_service.dart';
// import 'package:syslab_admin/service/notificationService.dart';
import 'package:syslab_admin/model/appointment_model.dart';
import 'package:syslab_admin/service/notification/firebase_notification.dart';
import 'package:syslab_admin/service/patient_service.dart';
// import 'package:syslab_admin/model/notificationModel.dart';
// import 'package:syslab_admin/service/Notification/handleFirebaseNotification.dart';
import 'package:syslab_admin/utilities/appbars.dart';
import 'package:syslab_admin/utilities/colors.dart';
import 'package:syslab_admin/utilities/fontStyle.dart';
import 'package:syslab_admin/utilities/toastMsg.dart';
import 'package:syslab_admin/widgets/bottomNavigationBarWidget.dart';
import 'package:syslab_admin/widgets/loadingIndicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ConfirmationPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String location;
  final String analyses;
  final double price;
  final String city;
  final String cin;
  final String des;
  final String appointmentType;
  final int serviceTimeMin;
  final String setTime;
  final String selectedDate;
  final String uId;
  final String userFcmId;
  const ConfirmationPage(
      {Key key,
      this.serviceTimeMin,
      this.setTime,
      this.selectedDate,
      this.appointmentType,
      this.phoneNumber,
      this.lastName,
      this.email,
      this.cin,
      this.firstName,
      this.city,
      this.location,
      this.analyses,
      this.price,
      this.des,
      this.uId,
      this.userFcmId})
      : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  String _adminFCMid = "";
  bool _isLoading = false;
  String _isBtnDisable = "false";
  String _uId = "";
  String _uName = "";
  String _userFCMid = "";

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _uId = widget.uId;
      _uName = widget.firstName + " " + widget.lastName;
      _userFCMid = widget.userFcmId;
    });
    _setAdminFcmId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Confirmation"),
      bottomNavigationBar: BottomNavBarWidget(
        isEnableBtn: _isBtnDisable=="false"?true:false,
        title: "Confirmer le rendez-vous",
        onPressed: () {
          _updateBookedSlot(); // Method handles all the booking system operation.
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                child: _isLoading
                    ? Center(child: LoadingIndicatorWidget())
                    : Center(
                        child: SizedBox(
                            height: 450,
                            width: double.infinity,
                            child: _cardView()),
                      )),
          ],
        ),
      ),
    );

    //    Container(
    //       color: bgColor,
    //       child: _isLoading
    //           ? Center(child: CircularProgressIndicator())
    //           : Center(
    //               child: Container(
    //                   height: 250,
    //                   width: double.infinity,
    //                   child: _cardView(patientDetailsArgs)),
    //             )),
    // );
  }

  Widget _cardView() {
    return Card(
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: btnColor,
              ),
              child: const Center(
                child: Text(
                  "Veuillez confirmer tous les d??tails",
                  style: TextStyle(
                    fontFamily: 'OpenSans-SemiBold',
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const Divider(),
            Text(
              "Nom du patient : ${widget.firstName} ${widget.lastName}",
              style: kCardSubTitleStyle,
            ),
            const SizedBox(height: 17),
            Text("Type de service : ${widget.appointmentType}",
                style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Temps de service : ${widget.serviceTimeMin} Minute",
                style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Date : ${widget.selectedDate}", style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Temps : ${widget.setTime}", style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("CIN patient : ${widget.cin}",
                style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Prix total : ${widget.price} Dhs", 
                style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            Text("Num??ro de t??l??phone : ${widget.phoneNumber}",
                style: kCardSubTitleStyle),
            const SizedBox(height: 17),
            const Text("Analyses : ", style: kCardSubTitleStyle),
            const SizedBox(height: 7),
            Text(widget.analyses, style: kCardSubTitleStyle),
          ],
        ),
      ),
    );
  }

  void _updateBookedSlot() async {

    setState(() {
      _isLoading = true;
      _isBtnDisable = "";
    });
    // final pattern = RegExp('\\s+'); //remove all space
    // final patientName = widget.firstName + widget.lastName;
    // String searchByName = patientName
    //     .toLowerCase()
    //     .replaceAll(pattern, ""); //lowercase all letter and remove all space
    DateTime now = DateTime.now();
    String createdTimeStamp = DateFormat('yyyy-MM-dd hh:mm').format(now);
    final appointmentModel = AppointmentModel(
        uName: _uName,
        cin: widget.cin,
        analyses: widget.analyses,
        price: widget.price.toString(),
        description: widget.des,
        appointmentType: widget.appointmentType,
        serviceTimeMin: widget.serviceTimeMin,
        appointmentTime: widget.setTime,
        appointmentDate: widget.selectedDate,
        appointmentStatus: "Pending",
        // searchByName: searchByName,
        uId: _uId,
        location: widget.location,
        createdTimeStamp:createdTimeStamp,
        updatedTimeStamp:createdTimeStamp,
    ); //initialize all values
    final insertStatus = await AppointmentService.addData(appointmentModel);

    if (insertStatus == "success") {
      // log(":::::::::::::::::::::;$insertStatus");
      
          ToastMsg.showToastMsg("R??serv?? avec succ??s");
          _handleSendNotification(widget.firstName, widget.lastName,
              widget.appointmentType, widget.selectedDate, widget.setTime);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/UsersListPage', ModalRoute.withName('/HomePage'));

    } else {
      ToastMsg.showToastMsg("Quelque chose s'est mal pass??. try again");
      Navigator.pop(context);
    }

    setState(() {
      _isLoading = false;
      _isBtnDisable = "false";
    });
  }

  void _setAdminFcmId() async {
    //loading if data till data fetched
    setState(() {
      _isLoading = true;
    });
    //fetch admin fcm id for sending messages to admin
    final fcmId = await FirebaseMessaging.instance.getToken();
    setState(() {
      _adminFCMid = fcmId;
    });
    setState(() {
      _isLoading = false;
    });
  }

  void _handleSendNotification(String firstName, String lastName,
      String appointmentType, String selectedDate, String setTime) async {
    //send notification to user
    await FirebaseNotification.sendPushMessage(
      _userFCMid, //admin fcm
      "R??serv?? avec succ??s", //title
      "Le rendez-vous a ??t?? pris le $selectedDate. En attente de confirmation", // body
    );
    await PatientService.updateIsAnyNotification("1", _uId);

    //send notification to admin app for booking confirmation
    // log("++++++++++++admin$_adminFCMid");
    await FirebaseNotification.sendPushMessage(
        _adminFCMid, //admin fcm
        "Nouveau rendez-vous", //title
        "$firstName $lastName pris rendez-vous le $selectedDate ?? $setTime" //body
        );

    await AdminService.updateIsAnyNotification("1");
  }

}
