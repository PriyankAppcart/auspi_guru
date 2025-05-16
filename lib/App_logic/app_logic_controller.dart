import 'dart:async';

import 'package:auspi_guru_flutter/App_logic/advanced_panchang_model.dart';
import 'package:auspi_guru_flutter/App_logic/commonStorage.dart';
import 'package:auspi_guru_flutter/App_logic/planets_extended_model.dart';
import 'package:auspi_guru_flutter/Moon_yog_calc.dart';
import 'package:auspi_guru_flutter/Notifications/LocalNotificationService.dart';
import 'package:auspi_guru_flutter/RemoteServices/RemoteServices.dart';
import 'package:auspi_guru_flutter/RemoteServices/check_internet.dart';
import 'package:auspi_guru_flutter/auspi_moon_calc.dart';
import 'package:auspi_guru_flutter/ghatika_calc.dart';
import 'package:auspi_guru_flutter/moon_rashi_calc.dart';
import 'package:auspi_guru_flutter/planets_rashi_nakshatra.dart';
import 'package:auspi_guru_flutter/sun_calc_data.dart';
import 'package:auspi_guru_flutter/timezone_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class app_logic_controller extends GetxController{

  var isDarkMode = false.obs; // Changed to RxBool for reactivity
  bool _isUserThemeSet = false; // Track if user has manually set theme

  /*
  * GPS DATA
  * */
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  //var tz= new timezone();

  /* GPS DATA*/
  //get CRashi => null;
  auspi_moon_calc MoonCalc = new auspi_moon_calc();
  sun_calc_data SunCalc = new sun_calc_data();
  moon_rashi_calc MoonRashiCalc = new moon_rashi_calc();
  planets_rashi_nakshatra PlanetRashiCalc = new planets_rashi_nakshatra();
  moon_yog_calc MoonYogCalc = new moon_yog_calc();
  ghatika_calc GhatikaCalc = new ghatika_calc();
  timezone_selelct MyTZ= new timezone_selelct();
  var TimeZone="";
  var TimeZone_new="";
  // var  moon_calc;
  // //Calendar calendar= Calendar.getInstance();
  //
  // //double DateSec =calendar.getTime().getTime()/1000;
  // //moon_calc=MoonCalc.phase(double.parse(DateSec));
  // // print(DateSec);
  // // print(moon_calc[1]);
   var cday=0.000;
  var cday_new=0.000;
  var Moon_speed=0.000;
  // //cday=moon_calc[1]+7;
  // //print(cday);
   var CNkh="";
  // var day=DateTime.now().weekday;
  // var hour=DateTime.now().hour;
  // // print(day);
  // var rgood;
  // var rbad;
  // var app;
  // var ngood;
  // var nbad;
  var SunData;
  var SunRashi="";
  var SunNksh="";
  var SunRutu="";
  var SunAyan="";
  var bharatiya_saur="";
  var Solar_deg=0.0;
  var Solar_deg_new=0.0;
  var Mars_deg=0.0;
  var Mercury_deg=0.0;
  var Jupiter_deg=0.0;
  var Venus_deg=0.0;
  var Saturn_deg=0.0;
  var Rahu_deg=0.0;
  var Ketu_deg=0.0;
  var Uranus_deg=0.0;
  var Neptune_deg=0.0;
  var Pluto_deg=0.0;
  var Ascendant_deg=0.0;
   var CRashi="";
   var days="blank";
   var graha="";
  // var snd=true;
   var Rahukal="";
  var Planet_NKSH="";
  var Planet_Rashi="";
  var Planet_RashiLord="";
  var Planet_NKSH_Lord="";
  var Planet_isRetro="";
  var Yog_str="";
  var Fal_str="";
  // var yogbad;
   var yoggood="";
  // var j=DateTime.now().minute;
  // List rashi = ["Mesh","Mesh","Vrushabh","Mithun","Karka",
  //   "Sinha","Kanya","Tula","Vrushchik","Dhanu","Makar","Kumbha","Meen"];
  //
  // int mth = DateTime.now().month;
  // int cmpTo = 0;
  // int cmpdate = DateTime.now().day;
  var current_Time="";
  var Moonphase;
  var SunriseData;
  var SunRise="";
  var SunSet="";
  var NextSunriseData;
  var NextSunRise="";
  var NextSunSet="";
  var PrevSunriseData;
  var PrevSunRise="";
  var PrevSunSet="";
  var MoonAge="";
  var MoonTithi="";
  var MoonIllumination="";

  var Planetdata;
  var Moondata;
  var YogData;

  var CurrentDayImage="sunday.png";

  var hour_rotation=0.0;
  var minutes_rotation=0;
  var seconds_rotation=0;
  var Hora_start="";
  var Hora_end="";
  var Hora_duration="";
  var equalTime=0.00;
  var equalTimeNight=0.00;
  var dayNight="day";
  List<String> GhatikaData=[];
  List Days_Week = ["Monday","Monday","Tuesday","Wednesday","Thursday",
    "Friday","Saturday","Sunday"];

  Map ?Agni_map;
  Map ?Tithi_Karan;
  var Agni_Present=false;
  var Agni_hand=0.000;
  var Tithi_hand=0.000;
  var AgniText="";
  var KaranText="";
  var Tithi_endtime="";
  var Karan_endtime="";
  var Nakshatra_endtime="";
  var Yog_endtime="";
  var Hindu_month="";
  var MoonRise="";
  var MoonSet="";


  var  today=(DateTime.now().microsecondsSinceEpoch/1000000).round();
  var nextDay=(DateTime.now().add(Duration(days: 1)).microsecondsSinceEpoch/1000000).round();
  var prevDay=(DateTime.now().subtract(Duration(days: 1)).microsecondsSinceEpoch/1000000).round();

  //var CurrentTime=(DateTime(DateTime.now().year,DateTime.now().month,prevDay1.day,7,52,0).microsecondsSinceEpoch/1000000).round();
  //var CurrentDate=DateTime(DateTime.now().year,DateTime.now().month,prevDay1.day,7,52,0);
  // var  today=(DateTime(DateTime.now().year,DateTime.now().month,4,7,52,0).microsecondsSinceEpoch/1000000).round();
  // var nextDay=(DateTime(DateTime.now().year,DateTime.now().month,5,7,52,0).microsecondsSinceEpoch/1000000).round();
  // var prevDay=(DateTime(DateTime.now().year,DateTime.now().month,3,7,52,0).microsecondsSinceEpoch/1000000).round();
  Timer ?timer;
  Timer ?timer_ghatika;
  var miliSec=0;
  var mypal =0.00;
  var myghatika =0.00;
  var prahar="";
  var myvipal =0.00;
  var rahukaalstartTime="";
  var rahukaalendTime="";
  var internetConnection = true.obs;
  var enableDeviceLocation = true.obs;
  var CityName;
  var City="";
  var State="";
  var Country="";
  List<Map<String, String>> mapLatLong =[
    {  "city":"Ujjain",
      "lat":"23.179300",
      "long":"75.784912"},
    {  "city":"Mumbai",
      "lat":"19.076090",
      "long":"72.877426"},
    {  "city":"Pune",
      "lat":"18.6546546",
      "long":"73.564656"},
    {  "city":"Delhi",
      "lat":"28.679079",
      "long":"77.069710"},
    {  "city":"Kolkata",
      "lat":"22.572645",
      "long":"88.363892"},
    {  "city":"Chennai",
      "lat":"13.067439",
      "long":"80.237617"},
    {  "city":"Nagpur",
      "lat":"21.146633",
      "long":"79.088860"},
    {  "city":"Ahmedabad",
      "lat":"23.033863",
      "long":"72.585022"},
    {  "city":"Guwahati ",
      "lat":"26.148043",
      "long":"91.731377"},
    {  "city":"Lucknow",
      "lat":"26.850000",
      "long":"80.949997"},
    {  "city":"Raipur",
      "lat":"21.250000",
      "long":"81.629997"},
    {  "city":"Belgaum",
      "lat":"15.852792",
      "long":"74.498703"},
    {  "city":"Washim",
      "lat":"20.100000",
      "long":"77.150002"},
  ];

  Map ?Hora_map;
  List Hora_Sunday_list =["-","Jupiter-Marriage","-","Sun-Rajseva",
    "-","-","Sun-Rajseva","-" ,"-",
    "-","-","Jupiter-Marriage","-",
    "Sun-Rajseva","-","-","-",
    "-","Jupiter-Marriage","-","Sun-Rajseva","-",
    "-","-","-"];

  List hora_Monday_list =["-","-","-","Moon-good for everything",
    "-","Jupiter-Marriage","Moon-good for everything","-","Jupiter-Marriage"
    ,"-","-","-","-","Moon-good for everything",
    "-","Jupiter-Marriage","-","-","-",
    "-","Moon-good for everything","-","Jupiter-Marriage","-",
    "-"];

  List hora_Tuesday_list =["-","-","Jupiter-Marriage",
    "Mars-Debate/War","-","-","Mars-Debate/War","-"
    ,"-","-","-","-",
    "Jupiter-Marriage","Mars-Debate/War","-","-"
    ,"-","-","-","Jupiter-Marriage",
    "Mars-Debate/War","-","-","-","-"];

  List hora_Wednesday_list =["-","-","-","Mercury-Learning"
    ,"-","-","Mercury-Learning","-",
    "-","Jupiter-Marriage","-","-","-",
    "Mercury-Learning","-","-"
    ,"Jupiter-Marriage","-","-","-","Mercury-Learning",
    "-","-","Jupiter-Marriage","-"];

  List hora_Thursday_list =["Mercury-Learning","Moon-good for everything","Saturn-Saving","Jupiter-Marriage"
    ,"Mars-Debate/War","Sun-Rajseva","Jupiter-Marriage","Mars-Debate/War","Sun-Rajseva"
    ,"Venus-Journey","Mercury-Learning","Moon-good for everything","Saturn-Saving","Jupiter-Marriage"
    ,"Mars-Debate/War","Sun-Rajseva","Venus-Journey","Mercury-Learning","Moon-good for everything"
    ,"Saturn-Saving","Jupiter-Marriage","Mars-Debate/War","Sun-Rajseva","Venus-Journey","Mercury-Learning"];

  List hora_Friday_list =["Jupiter-Marriage","-","-","Venus-Journey"
    ,"-","-","Venus-Journey","-","-"
    ,"-","Jupiter-Marriage","-","-","Venus-Journey"
    ,"-","-","-","Jupiter-Marriage","-"
    ,"-","Venus-Journey","-","-","-","Jupiter-Marriage"];

  List hora_Saturday_list =["-","-","-","Saturn-Saving"
    ,"Jupiter-Marriage","-","Saturn-Saving","Jupiter-Marriage","-"
    ,"-","-","-","-","Saturn-Saving"
    ,"Jupiter-Marriage","-","-","-","-"
    ,"-","Saturn-Saving","Jupiter-Marriage","-","-","-"];



  static final FlutterLocalNotificationsPlugin ?_notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  Future<void> onInit() async {

    super.onInit();

    await LocalNotificationService.configureLocalTimeZone();
    await initializeTheme();
    print("TimeZone${commonStorage.box.read('TimeZone')}");
    await checkGps();
   var notify_permission= _notificationsPlugin!.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();

   print("notify_permission $notify_permission");
//scheduleDailyTenAMNotification();

    print("nextDay$nextDay");
    days=Days_Week[DateTime.now().weekday];
    print("weekday$days");
    Agni_map={0:[7,1,4,5],1:[7,1,4,5],2:[7,3,4],3:[2,3,6],4:[1,2,5,6],5:[7,1,4,5],
              6:[7,3,4],7:[2,3,6],8:[1,2,5,6],9:[7,1,4,5],10:[7,3,4],
              11:[2,3,6],12:[1,2,5,6],13:[7,1,4,5],14:[7,3,4],15:[2,3,6],
              16:[1,2,5,6],17:[7,1,4,5],18:[7,3,4],19:[2,3,6],20:[1,2,5,6],
              21:[7,1,4,5],22:[7,3,4],23:[2,3,6],24:[1,2,5,6],25:[7,1,4,5],
              26:[7,3,4],27:[2,3,6],28:[1,2,5,6],29:[7,1,4,5],30:[7,3,4]};

    Tithi_Karan={0:["Kinstughna","Bava"],1:["Kinstughna","Bava"],2:["Baalav","Kaulav"],
      3:["Taiteel","Garaj"],4:["Vanij","Vishti"],5:["Bava","Baalav"],
      6:["Kaulav","Taiteel"],7:["Garaj","Vanij"],8:["Vishti","Bava"],
      9:["Baalav","Kaulav"],10:["Taiteel","Garaj"],11:["Vanij","Vishti"],
      12:["Bava","Baalav"],13:["Kaulav","Taiteel"],14:["Garaj","Vanij"],
      15:["Vishti","Bava"],16:["Baalav","Kaulav"],17:["Taiteel","Garaj"],
      18:["Vanij","Vishti"],19:["Bava","Baalav"],20:["Kaulav","Taiteel"],
      21:["Garaj","Vanij"],22:["Vishti","Bava"],23:["Baalav","Kaulav"],
      24:["Taiteel","Garaj"],25:["Vanij","Vishti"],26:["Bava","Baalav"],
      27:["Kaulav","Taiteel"],28:["Garaj","Vanij"],29:["Vishti","Chatushpaada"],30:["Shakuni","Naaga"]};


   // GhatikaCalc.getGhatikaPaldata();
   // print(DateTime.now().timeZoneName);
   // print(DateTime.now().timeZoneOffset);
    var tzsplit= DateTime.now().timeZoneOffset.toString().split(":");

    var tzhours=Time_Format(tzsplit[0]);
    var tzmins=Time_Format(tzsplit[1]);

   // print(tzhours);
   // print(tzmins);

    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var SunRise= await sharedPreferences.getString("SunRise").toString();
    // var SunSet= await sharedPreferences.getString("SunSet").toString();
    // var NextSunRise= await sharedPreferences.getString("NextSunRise").toString();
    // var NextSunSet= await sharedPreferences.getString("NextSunSet").toString();
    // var PrevSunRise= await sharedPreferences.getString("PrevSunRise").toString();
    // var PrevSunSet= await sharedPreferences.getString("PrevSunSet").toString();

    TimeZone=MyTZ.getTimezone("$tzhours:$tzmins");
    if(tzmins=="15")
    {
      TimeZone_new="$tzhours.25";
    }
    else if(tzmins=="30")
      {
        TimeZone_new="$tzhours.5";
        print("TimeZone_new$TimeZone_new");
      }
    else if(tzmins=="45")
      {
        TimeZone_new="$tzhours.75";
      }

    //print(TimeZone);

     timer = Timer. periodic(Duration(seconds: 1), (Timer t) {
     test();
    // GhatikaCalc.firstrun();


    // today=(DateTime.now().microsecondsSinceEpoch/1000000).round();
     //getMoonPhaseSummeryList();
     hour_rotation=((30*(DateTime.now().hour))+((6*(DateTime.now().minute)*30)/360)) ;
     minutes_rotation=6*(DateTime.now().minute);
     seconds_rotation=6*(DateTime.now().second);
     //print("seconds_rotation$seconds_rotation");

      // SetMoonData();
     //Solar_deg_new=0.00;
     SunData=SunCalc.getSundata(Solar_deg_new);
     bharatiya_saur=SunData[4];
     SunRashi=SunData[0];
     SunNksh=SunData[1];
     SunRutu=SunData[2];
     SunAyan=SunData[3];
     Solar_deg=double.parse(SunData[5]);
     Solar_deg=Solar_deg_new;

     //Solar_deg=253;

      //  print(DateTime.now().timeZoneName);
      //  print(DateTime.now().timeZoneOffset);
if(SunRise!="") {

 //  Moondata =
 //      MoonRashiCalc.getMoondata(SunRise, SunSet, NextSunRise, NextSunSet,PrevSunRise,PrevSunSet,MoonAge,Solar_deg.toString(),Hora_map!);
 //  CRashi = Moondata[0];
 //  CNkh = Moondata[1];
 //  graha = Moondata[2];
 //  Rahukal = Moondata[3];
 //  days = Moondata[4];
 // // cday = double.parse(Moondata[5]);
 //
 //  print("cdayc$cday");
 //  cday= cday+0.00016448772;
 //  print("cdayc$cday");
 //  Hora_duration=Moondata[6];
 //  Hora_start=Moondata[7];
 //  Hora_end=Moondata[8];
 //  rahukaalstartTime=Moondata[9];
 //  rahukaalendTime=Moondata[10];
 //  YogData =
 //      MoonYogCalc.getYogData(cday, SunRise, SunSet, NextSunRise, NextSunSet);
 //  Yog_str = YogData[0];
 //  Fal_str = YogData[1];
 //  yoggood = YogData[5];
 //  //print("cday${SunData[5]}");
 //
 //  print("cdayc$Solar_deg");
 //  print("cdayc$MoonAge");
 //  print("cdayc$cday");

  Planetdata=PlanetRashiCalc.getPlanetdata(Jupiter_deg, SunRise, SunSet, NextSunRise, NextSunSet, PrevSunRise, PrevSunSet, MoonAge, Solar_deg, Hora_map);
  graha = Planetdata[2];
   days = Planetdata[3];
  Hora_duration=Planetdata[5];
   Hora_start=Planetdata[6];
   Hora_end=Planetdata[7];

  // 22.161346 प्रात: , संगव , माध्यन्य , अपराण्ह , सायं 0.00016448772
var calc_moonage=double.parse(MoonAge)+0.000011;
  var calc_moontithi=0.0;
  var sun_moon_diff=0.0;
  var Solar_deg_calc=0.0;
if(cday<Solar_deg)
  {
    Solar_deg_calc =360.0-Solar_deg;
    sun_moon_diff=cday+Solar_deg_calc;
    calc_moontithi=sun_moon_diff/12;
  }
else if(cday>Solar_deg)
  {
    sun_moon_diff=cday-Solar_deg;
    calc_moontithi=sun_moon_diff/12;
  }
else
  {
    sun_moon_diff=cday-Solar_deg;
    calc_moontithi=sun_moon_diff/12;
  }
  print("Moontithi$calc_moontithi");
  MoonAge=("${calc_moonage.toStringAsFixed(6)} ");
if(calc_moontithi<15)
  {
    var calc_moonage_floor= calc_moontithi.floor()+1;
    MoonTithi=("$calc_moonage_floor Shukla Paksh");
   // MoonAge=("${calc_moonage.toStringAsFixed(6)} ");
  }
else
  {
    var calc_moonage_floor= calc_moontithi.floor()-15+1;
    MoonTithi=("$calc_moonage_floor Krushna Paksh");
   // MoonAge=calc_moonage.toStringAsFixed(6);
  }
print("Agni$calc_moonage");
var agnitithi=calc_moontithi+1;
   Tithi_hand=(agnitithi*12.0)-6.0;
  Agni_hand=252.0+(agnitithi*12.0);
if(Agni_hand>=360.0)
  {
    Agni_hand=Agni_hand-360.0;
  }
  if(Agni_map![(agnitithi.floor())].contains(DateTime.now().weekday))
  {
    Agni_Present=true;
    AgniText="Present";
    print("weekday -Present");
  }
  else
  {
    Agni_Present=false;
    AgniText="Not Present";
    print("weekday -Not Present");
  }

  if((agnitithi.floor()+0.5)<=agnitithi)
    {
      print("Karana0$agnitithi");
      print("Karana0${(agnitithi.floor()+0.5)}");
      print("Karana0${Tithi_Karan![(agnitithi.floor())][1]}");
      KaranText=Tithi_Karan![(agnitithi.floor())][1];
    }
  else
    {
      print("Karana1${Tithi_Karan![(agnitithi.floor())][0]}");
      KaranText=Tithi_Karan![(agnitithi.floor())][0];
    }

  //cday=126.5177;
  current_Time = "${Time_Format(DateTime
      .now()
      .hour)} : ${Time_Format(DateTime.now().minute)} : ${Time_Format(DateTime
      .now()
      .second)}";
}

     });



  }



  
// Initialize theme based on system or stored preference
  Future<void> initializeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Check if user has manually set a theme
    final storedTheme = prefs.getString('theme');
    if (storedTheme != null) {
      isDarkMode.value = storedTheme == 'dark';
      _isUserThemeSet = true;
    } else {
      // Use system theme if no user preference is set
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = Get.context;
        if (context != null) {
          final brightness = MediaQuery.of(context).platformBrightness;
  
          isDarkMode.value = brightness == Brightness.dark;
        }
      });
      _isUserThemeSet = false;
    }
    update();
  }

  // Toggle theme and save user preference
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _isUserThemeSet = true;
    _saveThemePreference();
    update();
  }

  // Save theme preference to SharedPreferences
  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', isDarkMode.value ? 'dark' : 'light');
  }

  // Update isDarkMode based on system theme (used by WidgetsBindingObserver)
  void updateSystemTheme(Brightness brightness) {
    if (!_isUserThemeSet) {
      isDarkMode.value = brightness == Brightness.dark;
      update();
    }
  }

Future<void> GhatikaCalFunction()
async {
  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // var SunRise= await sharedPreferences.getString("SunRise").toString();
  // var SunSet= await sharedPreferences.getString("SunSet").toString();
  // var NextSunRise= await sharedPreferences.getString("NextSunRise").toString();
  // var NextSunSet= await sharedPreferences.getString("NextSunSet").toString();
  // var PrevSunRise= await sharedPreferences.getString("PrevSunRise").toString();
  // var PrevSunSet= await sharedPreferences.getString("PrevSunSet").toString();
print("SunRise$SunRise");
  var myvipal_cnt =0.00;
  var mypal_cnt =0.00;
  var myghatika_cnt =0.00;
  //GhatikaCalc.firstrun();
// timer_ghatika = Timer. periodic(Duration(seconds: 1), (Timer t) {
//   //GhatikaData=GhatikaCalc.getGhatikaPaldata();
//   if(SunRise!="") {
//     // GhatikaData = GhatikaCalc.getGhatikaPaldata("06:00:00","18:00:00","06:00:00","18:00:00","06:00:00","18:00:00");
//     GhatikaData = GhatikaCalc.getGhatikaPaldata(SunRise, SunSet, NextSunRise, NextSunSet,PrevSunRise,PrevSunSet);
//   }
//   else{
//     GhatikaData = GhatikaCalc.getGhatikaPaldata("06:00:00","18:00:00","06:00:00","18:00:00","06:00:00","18:00:00");
//   }
//   miliSec=miliSec+DateTime.now().millisecond;
//   // mypal=double.parse("57.00");
//   // myghatika=double.parse(GhatikaData[1]);
//   mypal=double.parse(GhatikaData[2]);
//   myghatika=double.parse(GhatikaData[1]);
//   myvipal=double.parse(GhatikaData[3]);
//   // print("myPal-0--$mypal");
//   // myvipal_cnt=double.parse((miliSec/530).toString());
//   // print("myvipal1-$myvipal_cnt");
//   // if(myvipal_cnt>=60)
//   // {
//   //
//   //   mypal_cnt=double.parse((myvipal_cnt/60).toString());
//   // }
//   // if(mypal_cnt>=60)
//   // {
//   //   // mypal=0.00;
//   //   myghatika_cnt=double.parse((mypal_cnt/60).toString());;
//   // }
//   //
//   // myvipal= (myvipal_cnt- double.parse((mypal_cnt.floor()*60).toString())).floor();
//   // mypal=mypal+mypal_cnt;
//   // print("myPal---$mypal");
//   // if(mypal>=60.0 && myghatika_cnt==0 )
//   //   {
//   //     mypal=mypal-60;
//   //     myghatika=myghatika+1;
//   //   }
//   // else if(mypal>=60.0 && myghatika_cnt>0 )
//   //   {
//   //     mypal=mypal-((myghatika_cnt+1)*60);
//   //     myghatika=myghatika+1;
//   //   }
//   //
//   // print("myPal-2--$mypal");
//   // myghatika=myghatika+myghatika_cnt;
//   // // print("miliSec$miliSec");
//   // print("myvipal_cnt$myvipal_cnt");
//   // print("mypal_cnt$mypal_cnt");
//   // print("myghatika_cnt$myghatika_cnt");
//   //
//   // print("myvipal$myvipal");
//   //  print("mypal$mypal");
//   // print("myghatika$myghatika");
//   var g_rot= myghatika*6;
//   prahar=GhatikaData[0];
//   if(g_rot<0)
//   {
//     g_rot=g_rot+360;
//   }
//   if(g_rot<=45)
//   {
//     prahar="1";
//   }
//   else if(g_rot>45&&g_rot<=90)
//   {
//     prahar="2";
//   }
//   else if(g_rot>90&&g_rot<=135)
//   {
//     prahar="3";
//   }
//   else if(g_rot>135&&g_rot<=180)
//   {
//     prahar="4";
//   }
//   else if(g_rot>180&&g_rot<=225)
//   {
//     prahar="5";
//   }
//   else if(g_rot>225&&g_rot<=270)
//   {
//     prahar="6";
//   }
//   else if(g_rot>270&&g_rot<=315)
//   {
//     prahar="7";
//   }
//   else if(g_rot>315&&g_rot<=360)
//   {
//     prahar="8";
//   }
//
//   MoonIllumination="प्रहर:${prahar},घटिका:${myghatika.floor().toStringAsFixed(0)},पळ:${mypal.floor().toStringAsFixed(0)},"
//       "विपळ:${myvipal.floor()}";
// });
  update();
}
  Future <void> scheduleDailyTenAMNotification() async {

    await _notificationsPlugin!.zonedSchedule(
        999,
        'daily scheduled notification title',
        'daily scheduled notification body',
        nextInstanceOfTenAM(),
     // tz.TZDateTime.now(tz.local).add(Duration(seconds: 10)),
        const NotificationDetails(
          android: AndroidNotificationDetails('main_channel', 'Main Channel',
              channelDescription: "ashwin",
              importance: Importance.max,
              priority: Priority.max),
        ),

        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,);
        //matchDateTimeComponents: DateTimeComponents.time);
  }
   tz.TZDateTime nextInstanceOfTenAM() {
    print("Here in TZ");
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute,now.second);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(seconds: 30));

    }
    print(scheduledDate.toString());
    return scheduledDate;
  }
 String Time_Format(num)
  {
    if(num.toString().length==1)
      {
        return "0$num";
      }
    else
      {
        return "$num";
      }
  }
test()
{
  var DateSec="${(DateTime.now().microsecondsSinceEpoch/1000000).round()}";
  print("lat$lat");
  print("long$long");
  update();
}
  Future getMoonPhaseSummeryList() async{

    try{
      var transactionSummeryDetails = await RemoteServices.fetchTSLis('http://api.farmsense.net/v1/moonphases/?d=$today');
      print("logoutDetails : $transactionSummeryDetails");
      Moonphase = transactionSummeryDetails;
getData(Moonphase);
      MoonAge=Moonphase[0].age.toStringAsFixed(6);
      MoonIllumination=Moonphase[0].illumination.toString();
      update();
    }finally{

    }

  }
  Future getSunSummeryList() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("lat",lat );
    var val1= sharedPreferences.getString("lat");
    await sharedPreferences.setString("long",long );
    var val2 = sharedPreferences.getString("long");
    await sharedPreferences.setString("TimeZone",TimeZone );
    var val3= sharedPreferences.getString("TimeZone");

    print("sharedPreferences- $val1-$val2-$val3");
    try{
      var transactionSummeryDetails = await RemoteServices.fetchSunriseData('http://api.farmsense.net/v1/daylengths/?d=$today&lat=$lat&lon=$long&tz=$TimeZone');
      //print("logoutDetails : $transactionSummeryDetails");
      SunriseData = transactionSummeryDetails;
     // getData(SunriseData);
      SunRise=SunriseData[0].sunrise;
      SunSet=SunriseData[0].sunset;
       sharedPreferences.setString("SunRise",SunRise );
       sharedPreferences.setString("SunSet",SunSet );
       print("Sunrise");
      print( await sharedPreferences.getString("SunRise").toString());
      update();
    }finally{

    }

  }
  Future getNextdaySunSummeryList() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try{
      var transactionSummeryDetails = await RemoteServices.fetchSunriseData('http://api.farmsense.net/v1/daylengths/?d=$nextDay&lat=$lat&lon=$long&tz=$TimeZone');
     // print("logoutDetails : $transactionSummeryDetails");
      NextSunriseData = transactionSummeryDetails;
      // getData(SunriseData);
      NextSunRise=NextSunriseData[0].sunrise;
     // print("NextSunRise$NextSunRise");
      NextSunSet=NextSunriseData[0].sunset;
       sharedPreferences.setString("NextSunRise",NextSunRise );
       sharedPreferences.setString("NextSunSet",NextSunSet );
      update();
    }finally{

    }

  }

  Future getPrevdaySunSummeryList() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try{
      var transactionSummeryDetails = await RemoteServices.fetchSunriseData('http://api.farmsense.net/v1/daylengths/?d=$prevDay&lat=$lat&lon=$long&tz=$TimeZone');
      //print("logoutDetails : $transactionSummeryDetails");
      PrevSunriseData = transactionSummeryDetails;
      // getData(SunriseData);
      PrevSunRise=PrevSunriseData[0].sunrise;
     // print("NextSunRise$NextSunRise");
      PrevSunSet=PrevSunriseData[0].sunset;
       sharedPreferences.setString("PrevSunRise",PrevSunRise );
       sharedPreferences.setString("PrevSunSet",PrevSunSet );
      Future.delayed(const Duration(milliseconds: 200), () {

        GhatikaCalFunction();
      });

      update();
    }finally{

    }

  }
  Future getCityNameSummeryList() async{

    try{


      var transactionSummeryDetails = await RemoteServices.fetchCityState('https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$lat&longitude=$long&localityLanguage=en');
      print("logoutDetails : $transactionSummeryDetails");
      CityName = transactionSummeryDetails;

      print("CityName");
      print(CityName.city);
      City=CityName.city;
      State=CityName.principalSubdivision;
      Country=CityName.countryName;
      update();
    }finally{

    }

  }
  Future<dynamic> callApi(isFlag,lat,long) async{

    try{
      var details;
      if(isFlag){
        details = await RemoteServices.fetchPostData('https://json.astrologyapi.com/v1/advanced_panchang',lat,long,TimeZone_new);

      }else{
        details = await RemoteServices.fetchPostData('https://json.astrologyapi.com/v1/planets/extended',lat,long,TimeZone_new);
      }
      if(isFlag){
        var AdvancedataDetails = advancedPanchangModelFromJson(details);
        Tithi_endtime="(${AdvancedataDetails.tithi.endTime.hour} : ${AdvancedataDetails.tithi.endTime.minute} :"
            " ${AdvancedataDetails.tithi.endTime.second})";
        Karan_endtime="(${AdvancedataDetails.karan.endTime.hour} : ${AdvancedataDetails.karan.endTime.minute} : "
            "${AdvancedataDetails.karan.endTime.second})";
        Nakshatra_endtime="(${AdvancedataDetails.nakshatra.endTime.hour} : ${AdvancedataDetails.nakshatra.endTime.minute} : "
            "${AdvancedataDetails.nakshatra.endTime.second})";
        Yog_endtime="${AdvancedataDetails.yog.details.yogName} (${AdvancedataDetails.yog.endTime.hour} : ${AdvancedataDetails.yog.endTime.minute} :"
            " ${AdvancedataDetails.yog.endTime.second})";
         Hindu_month= AdvancedataDetails.hinduMaah.amanta;
         MoonRise=AdvancedataDetails.moonrise;
        MoonSet=AdvancedataDetails.moonset;

      }else{
        var PlanetdataDetails = planetsExtendedModelFromJson(details);
        Solar_deg_new=PlanetdataDetails[0].fullDegree;
        cday_new=PlanetdataDetails[1].fullDegree;
        cday = cday_new;
        Moon_speed = PlanetdataDetails[1].speed;
        Mars_deg=PlanetdataDetails[2].fullDegree;
        Mercury_deg=PlanetdataDetails[3].fullDegree;

        Jupiter_deg=PlanetdataDetails[4].fullDegree;
        Planet_NKSH=PlanetdataDetails[4].nakshatra;
        Planet_Rashi=PlanetdataDetails[4].sign;
        Planet_RashiLord=PlanetdataDetails[4].signLord;
        Planet_NKSH_Lord=PlanetdataDetails[4].nakshatraLord;
        Planet_isRetro=PlanetdataDetails[4].isRetro;

        Venus_deg=PlanetdataDetails[5].fullDegree;
        Saturn_deg=PlanetdataDetails[6].fullDegree;
        Rahu_deg=PlanetdataDetails[7].fullDegree;
        Ketu_deg=PlanetdataDetails[8].fullDegree;
        Uranus_deg=PlanetdataDetails[9].fullDegree;
        Neptune_deg=PlanetdataDetails[10].fullDegree;
        Pluto_deg=PlanetdataDetails[11].fullDegree;
        Ascendant_deg=PlanetdataDetails[12].fullDegree;
       print("Moon_speed $Moon_speed");
       print("Solar_deg_new $Solar_deg_new");
       print("cday_new $cday_new");
      }
      update();
    }finally{

    }
  }

  // checkGps() async {
  //   print('In checkGps');
  //   servicestatus = await Geolocator.isLocationServiceEnabled();
  //   if(servicestatus){
  //     permission = await Geolocator.checkPermission();
  //
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         print('Location permissions are denied');
  //       }else if(permission == LocationPermission.deniedForever){
  //         print("'Location permissions are permanently denied");
  //       }else{
  //         haspermission = true;
  //       }
  //     }else{
  //       haspermission = true;
  //     }
  //
  //     if(haspermission){
  //       update();
  //
  //       getLocation();
  //     }
  //   }else{
  //     print("GPS Service is not enabled, turn on GPS location");
  //   }
  //
  //   update();
  // }
  checkGps() async {

    /*Location location = new Location();
    bool ison = await location.serviceEnabled();
    if (!ison) { //if defvice is off
      bool isturnedon = await location.requestService();
      if (isturnedon) {
        print("GPS device is turned ON");
      }else{
        print("GPS Device is still OFF");
      }
    }*/

    print('In checkGps');
    servicestatus = await Geolocator.isLocationServiceEnabled();

    if(servicestatus){
      print("GPS Service");
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {

          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          // await Geolocator.requestPermission();
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        //  update();
        enableDeviceLocation.value = true;
        print("getLfocation call=======");
        if(await CheckInternet.checkInternet()) {
          updateFlag(true);
          getLocation();
        }else{
          updateFlag(false);
        }
        //getLocation();

      }
    }else {
  print("GPS Service is not enabled, prompting to turn on GPS location");
  enableDeviceLocation.value = false;
  await Geolocator.openLocationSettings();
  // Recheck location services after returning from settings
  servicestatus = await Geolocator.isLocationServiceEnabled();
  if (servicestatus) {
    // Location services enabled, retry permission check
    print("GPS Service enabled, checking permissions");
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        Get.snackbar(
          "Location Permission",
          "Location permission is required for accurate data.",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () => Geolocator.requestPermission(),
            child: Text("Retry"),
          ),
        );
        enableDeviceLocation.value = false;
      } else if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        Get.snackbar(
          "Location Permission",
          "Location permission is permanently denied. Please enable it in settings.",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () => Geolocator.openAppSettings(),
            child: Text("Open Settings"),
          ),
        );
        enableDeviceLocation.value = false;
      } else {
        haspermission = true;
      }
    } else if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      Get.snackbar(
        "Location Permission",
        "Location permission is permanently denied. Please enable it in settings.",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => Geolocator.openAppSettings(),
          child: Text("Open Settings"),
        ),
      );
      enableDeviceLocation.value = false;
    } else {
      haspermission = true;
    }

    if (haspermission) {
      enableDeviceLocation.value = true;
      print("getLocation call=======");
      if (await CheckInternet.checkInternet()) {
        updateFlag(true);
        await getLocation();
      } else {
        updateFlag(false);
      }
    }
  } else {
    // Location services still disabled
    print("GPS Service still disabled");
    enableDeviceLocation.value = false;
    Get.snackbar(
      "Location Services",
      "Please enable GPS in device settings to continue.",
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 5),
    );
  }}

    update();
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    update();

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position)  async {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();
      commonStorage.box.write('long',long);
      commonStorage.box.write('lat',lat);
      commonStorage.box.write('TimeZone',TimeZone);

      print("TimeZone${commonStorage.box.read('TimeZone')}");



      getMoonPhaseSummeryList();
        getSunSummeryList();
        getNextdaySunSummeryList();

        getPrevdaySunSummeryList();
      getCityNameSummeryList();
      callApi(false,position.latitude,position.longitude);
      callApi(true,position.latitude,position.longitude);
      Hora_map={0:Hora_Sunday_list,1:hora_Monday_list,2:hora_Tuesday_list,3:hora_Wednesday_list,
        4:hora_Thursday_list,5:hora_Friday_list,6:hora_Saturday_list,7:Hora_Sunday_list};

      update();

    });
  }
  getLocationPreset(preset_lat, preset_long) async {

    enableDeviceLocation.value = true;
    //var preset_lat=18.516726;
   // var preset_long=73.856255;
      long = preset_long;
      lat = preset_lat;
      commonStorage.box.write('long',long);
      commonStorage.box.write('lat',lat);
      commonStorage.box.write('TimeZone',TimeZone);

      print("TimeZone${commonStorage.box.read('TimeZone')}");



      getMoonPhaseSummeryList();
      getSunSummeryList();
      getNextdaySunSummeryList();

      getPrevdaySunSummeryList();
      getCityNameSummeryList();
      callApi(false,preset_lat,preset_long);
      callApi(true,preset_lat,preset_long);
      Hora_map={0:Hora_Sunday_list,1:hora_Monday_list,2:hora_Tuesday_list,3:hora_Wednesday_list,
        4:hora_Thursday_list,5:hora_Friday_list,6:hora_Saturday_list,7:Hora_Sunday_list};

      update();


  }
  void updateFlag(bool flag) {
  internetConnection.value = flag;
  update();
}
  void getData(moonphase) {

    print(moonphase[0].illumination);
  }
  PageController controller = PageController();
  var pageindicator = 0;
  indicator(page){
    pageindicator = page;
    print("page $page");
    update();
  }
}