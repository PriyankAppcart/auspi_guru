



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auspi_guru_flutter/App_logic/app_logic_controller.dart';
import 'package:auspi_guru_flutter/SizeConfig.dart';
import 'dart:math';

class WidgetViewPage extends StatelessWidget {
  final String dialType;

  WidgetViewPage({Key? key, required this.dialType}) : super(key: key);

  final app_logic_controller logicController = Get.find<app_logic_controller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Text(
          'Back',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 2 * SizeConfig.textMultiplier,
            fontFamily: 'Abel',
          ),
        ),
        backgroundColor: Color(0xFF29b1ef),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: GetBuilder<app_logic_controller>(
        builder: (controller) => Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: dialType == "planet_position"
                ? planet_position(controller)
                : sevenday_dial(controller, 50, 50), // Adjust size as needed
          ),
        ),
      ),
    );
  }

  Widget planet_position(app_logic_controller controller) {
    return Container(
      height: 50 * SizeConfig.heightMultiplier,
      width: 50 * SizeConfig.heightMultiplier,
      child: Stack(
        children: [
          Center(
            child: Image.asset("assets/chandra.png", fit: BoxFit.fill),
          ),
          Transform.rotate(
            angle: (controller.hour_rotation * pi) / 180,
            child: Center(
              child: Image.asset("assets/hourhand.png", fit: BoxFit.fitHeight),
            ),
          ),
          Transform.rotate(
            angle: ((double.parse("${controller.minutes_rotation}")) * pi) / 180,
            child: Center(
              child: Image.asset("assets/minutehand.png", fit: BoxFit.fitHeight),
            ),
          ),
          Transform.rotate(
            angle: ((double.parse("${controller.seconds_rotation}")) * pi) / 180,
            child: Center(
              child: Image.asset("assets/sechand.png",
                  fit: BoxFit.fitHeight, color: Colors.black),
            ),
          ),
          Transform.rotate(
            angle: ((double.parse("${controller.Jupiter_deg}")) * pi) / 180,
            child: Center(
              child: Image.asset("assets/guru.png",
                  fit: BoxFit.fitHeight, color: Colors.pinkAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget sevenday_dial(app_logic_controller controller, double height, double width) {
    return Container(
      height: height * SizeConfig.heightMultiplier,
      width: width * SizeConfig.heightMultiplier,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/${controller.days.toLowerCase()}.png",
              fit: BoxFit.fill,
            ),
          ),
          Transform.rotate(
            angle: (controller.hour_rotation * pi) / 180,
            child: Center(
              child: Image.asset("assets/hourhand.png", fit: BoxFit.fitHeight),
            ),
          ),
          Transform.rotate(
            angle: ((double.parse("${controller.minutes_rotation}")) * pi) / 180,
            child: Center(
              child: Image.asset("assets/minutehand.png", fit: BoxFit.fitHeight),
            ),
          ),
          Transform.rotate(
            angle: ((double.parse("${controller.seconds_rotation}")) * pi) / 180,
            child: Center(
              child: Image.asset("assets/sechand.png", fit: BoxFit.fitHeight),
            ),
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'App_logic/app_logic_controller.dart';
// import 'SizeConfig.dart';


// class WidgetViewPage extends StatelessWidget {

//   //var imgList;
//   var g_dial;
//   WidgetViewPage({@required this.g_dial});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//           floatingActionButton: FloatingActionButton(
//             child: Text('Back',
//                 style: TextStyle(
//                   color:  Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize:
//                   2 * SizeConfig.textMultiplier,fontFamily: 'Abel',)),
//             backgroundColor: Color(0xFF29b1ef),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         body: GetBuilder<app_logic_controller>(
//             init: app_logic_controller(),
//             builder: (controller) =>  Center(
//           child:g_dial
//           ),
//         )
//     );
//     // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
//     // return Scaffold(
//     //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     //   floatingActionButton: FloatingActionButton(
//     //     child: Text('Back',
//     //         style: TextStyle(
//     //           color:  Colors.white,
//     //           fontWeight: FontWeight.bold,
//     //           fontSize:
//     //           2 * SizeConfig.textMultiplier,fontFamily: 'Abel',)),
//     //     backgroundColor: Color(0xFF29b1ef),
//     //     onPressed: () {
//     //       Navigator.of(context).pop();
//     //     },
//     //   ),
//     //   body: Column(
//     //     children: [
//     //       Container(
//     //           color: Colors.white,
//     //           height: 100 * SizeConfig.heightMultiplier,
//     //           width: 100 * SizeConfig.widthMultiplier,
//     //
//     //           child: PhotoViewGallery.builder(
//     //             scrollPhysics:  BouncingScrollPhysics(),
//     //             backgroundDecoration:BoxDecoration(color: Colors.white),
//     //             builder: (BuildContext context, int index) {
//     //               return PhotoViewGalleryPageOptions(
//     //                 imageProvider: AssetImage(imgList[index]),
//     //                 initialScale: PhotoViewComputedScale.contained * 0.8,
//     //                 heroAttributes: PhotoViewHeroAttributes(tag: imgList[index]),
//     //
//     //               );
//     //             },
//     //             itemCount: imgList.length,
//     //             loadingBuilder: (context, event) => Center(
//     //               child: Container(
//     //                 color: Colors.white,
//     //                 width: 90.0,
//     //                 height: 90.0,
//     //                 child: CircularProgressIndicator(
//     //                   strokeWidth: 1.5 * SizeConfig.widthMultiplier,
//     //                   backgroundColor:Colors.white,
//     //                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF29b1ef)),
//     //                   // semanticsLabel: "Downloading file abc.mp3",
//     //                   // semanticsValue: "Percent " + (100).toString() + "%",
//     //                   value: event == null
//     //                       ? 0
//     //                       : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
//     //                 ),
//     //               ),
//     //             ),
//     //           )
//     //       ),
//     //     ],
//     //   ),
//     // );


//   }


// }