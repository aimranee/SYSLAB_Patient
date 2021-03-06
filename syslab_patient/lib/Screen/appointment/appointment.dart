import 'package:get/get.dart';
import 'package:patient/Screen/appointment/choosetimeslots.dart';
import 'package:patient/utilities/color.dart';
import 'package:patient/utilities/decoration.dart';
import 'package:patient/utilities/style.dart';
import 'package:patient/widgets/auth_screen.dart';
import 'package:patient/widgets/appbars_widget.dart';
import 'package:patient/widgets/bottom_navigation_bar_widget.dart';
import 'package:patient/widgets/custom_drawer.dart';
import 'package:patient/widgets/error_widget.dart';
import 'package:patient/widgets/image_widget.dart';
import 'package:patient/widgets/loading_indicator.dart';
import 'package:patient/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:patient/Service/appointment_type_service.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key key}) : super(key: key);

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int _number;
  int _serviceTimeMin;
  String _appointmentType = "";
  String _openingTime = "";
  String _closingTime = "";
  bool isConn = Get.arguments;
  final bool _isLoading = false;

  @override
  void initState() {
     
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        bottomNavigationBar: _isLoading
          ? const LoadingIndicatorWidget()
          : BottomNavigationStateWidget(
          title: "Suivant",
          onPressed: () {
            Get.to(() => 
              ChooseTimeSlotPage(
                appointmentType: _appointmentType,
                serviceTimeMin: _serviceTimeMin,
                openingTime: _openingTime,
                closingTime: _closingTime,
                isConn : isConn
              ),
            );
          },
          clickable: _appointmentType,
        ),
        drawer: CustomDrawer(isConn: isConn),
        body: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            CAppBarWidget(title: "Demander Rendez-vous", isConn: isConn), //common app bar
            Positioned(
                top: 90,
                left: 0,
                right: 0,
                bottom: 0,
                child:
                //_stopBooking?showDialogBox():
                !isConn ? const AuthScreen() : _buildContent()),
          ],
        ));
  }

  Widget _buildContent() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: IBoxDecoration.upperBoxDecoration(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.only(top: 10.0, left: 20, right: 10),
                child: Center(
                  child: Text("Quel type de rendez-vous", style: kPageTitleStyle))),
            FutureBuilder(
                future: AppointmentTypeService.getData(), //fetch all appointment types
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.length == 0
                        ? const NoDataWidget()
                        : _buildGridView(snapshot.data);
                  } else if (snapshot.hasError) {
                    return const IErrorWidget();
                  } else {
                    return const LoadingIndicatorWidget();
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(appointmentTypesDetails) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: GridView.count(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: .9,
        crossAxisCount: 2,
        children: List.generate(appointmentTypesDetails.length, (index) {
          return _cardImg(appointmentTypesDetails[index], index + 1); //send type details and index with increment one
        }),
      ),
    );
  }

  Widget _cardImg(
    appointmentTypesDetails,
    num num,
  ) {
    // //print("hhhhhhhhhhh : "+appointmentTypesDetails.day);
    return GestureDetector(
      onTap: () {
        _serviceTimeMin = appointmentTypesDetails.forTimeMin;
        setState(() {
          if (_number == num) {
            //if user again tap
            setState(() {
              _appointmentType = ""; //clear name
              _number = 0;
              //set to zero
            });
          } else {
            //if user taps
            setState(() {
              _appointmentType = appointmentTypesDetails.title; //set the service name
              _serviceTimeMin = appointmentTypesDetails.forTimeMin; //set the service time
              _openingTime = appointmentTypesDetails.openingTime;
              _closingTime = appointmentTypesDetails.closingTime;
            });

            _number = num; //set the number to taped card index+1
          }
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        child: Stack(
          clipBehavior: Clip.none,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 40,
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: ImageBoxFillWidget(
                    // imageUrl: appointmentTypesDetails.imageUrl,
                  ) //get images
                  ),
            ),
            Positioned.fill(
                left: 0,
                right: 0,
                bottom: 0,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: num == _number //if tap card value index+1 match with number value it mean user tap on the card
                        ? Container(
                            width: double.infinity,
                            height: 40,
                            color: btnColor,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(appointmentTypesDetails.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OpenSans-Bold',
                                        fontSize: 16.0,
                                      )),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(appointmentTypesDetails.title,
                                      style: const TextStyle(
                                        fontFamily: 'OpenSans-Bold',
                                        fontSize: 16.0,
                                      )),
                                ],
                              ),
                            ),
                          )))
          ],
        ),
      ),
    );
  }
}
