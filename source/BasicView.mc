using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Timer as Timer;

enum {
  SCREEN_SHAPE_CIRC = 0x000001,
  SCREEN_SHAPE_SEMICIRC = 0x000002,
  SCREEN_SHAPE_RECT = 0x000003
}

// this array corresponds to each minute tilemap [0..59]
// each tile is an array of signed 32-bit integers,
// and each integer is 4x byte-packed as follows (font-char, x-pos, y-pos, padding).
// ie; a packed value of 982558720 results in (char: 58, xpos: 144, ypos: 168, pad: 0), this then used to drawText char(58) at (144,168).
// we do this to save 4x memory.
const hands = [
  [23068672,39852032,58202112,73412608,90195968,106979328],[123731968,142082048,157292544,175642624,190853120,209203200,224413696,241197056],[259522560,274733056,293083136,308293632,326643712,341854208,360204288,375414784,393764864],[410517504,427300864,445650944,459288576,477638656,492849152,511199232,526409728,544759808],[561512448,579862528,595073024,613423104,628633600,646983680,660621312,678971392,694181888,712531968],[729290752,747640832,762851328,781201408,794839040,813189120,828399616,846749696],[863508480,881858560,897069056,915419136,929056768,947406848,962617344,980967424],[999299072,1017649152,1031286784,1049636864,1067986944,1080051712,1098401792,1116751872,1130389504,1148739584],[1168644096,1182281728,1200631808,1218981888,1232619520,1250969600,1269319680,1281384448,1299734528],[1318072320,1336422400,1350060032,1368410112,1386760192,1398824960,1417175040],[1435512832,1453862912,1467500544,1485850624,1504200704,1516265472,1534615552],[1552953344,1571303424,1589653504,1601718272,1620068352,1638418432,1656768512,1667260416,1685610496,1703960576],[1719158784,1737508864,1755858944,1774209024,1784700928,1803051008,1821401088,1839751168],[1854949376,1873299456,1891649536,1902141440,1920491520,1938841600,1957191680,1975541760],[1989167104,2007517184,2025867264,2036359168,2054709248,2073059328,2091409408,2109759488],[2120245248,2138595328,-2138021888,-2119671808,-2101321728,-2086111232],[-2074058752,-2055708672,-2037358592,-2019008512,-2000658432,-1987020800,-1968670720,-1950320640],[-1939841024,-75997184,-1903140864,-1884790784,-1872726016,-1854375936,-1836025856,-1817675776,-1799325696],[-1788846080,-1770496000,-1752145920,-1738508288,-1720158208,-1701808128,-1683458048,-1665107968,-1649897472],[-1637851136,-1619501056,-1604290560,-1585940480,-1567590400,-1549240320,-1530890240,-1517252608,-1498902528,-1480552448],[-1470078976,-1451728896,-1436518400,-1418168320,-1399818240,-1381468160,-1366257664,-1347907584],[-1335861248,-1317511168,-1302300672,-1283950592,-1265600512,-1247250432,-1232039936,-1213689856],[-1201643520,-1183293440,-1168082944,-1149732864,-1131382784,-1116172288,-1097822208,-1079472128,-1064261632,-1045911552],[-1033871360,-1017088000,-998737920,-980387840,-965177344,-946827264,-931616768,-913266688,-894916608],[-882876416,-866093056,-847742976,-830959616,-812609536,-797399040,-779048960],[-765435904,-748652544,-730302464,-713519104,-695169024,-679958528,-661608448],[-647995392,-631212032,-612861952,-597651456,-579301376,-560951296,-545740800,-527390720,-512180224,-493830144],[-480223232,-463439872,-445089792,-429879296,-411529216,-396318720,-377968640,-361185280],[-346005504,-329222144,-312438784,-294088704,-278878208,-260528128,-245317632,-226967552],[-211787776,-195004416,-178221056,-159870976,-144660480,-126310400,-111099904,-92749824],
  [23093248,39876608,56659968,71870464,90220544,107003904],[123756544,140539904,155750400,174100480,189310976,207661056,222871552,241221632],[256401408,274751488,289961984,308312064,323522560,341872640,357083136,375433216,390643712],[407396352,425746432,440956928,459307008,474517504,492867584,506505216,524855296,541638656],[558391296,576741376,591951872,610301952,623939584,642289664,657500160,675850240,691060736,709410816],[726163456,744513536,759724032,778074112,791711744,810061824,825272320,843622400],[860381184,878731264,893941760,912291840,925929472,944279552,959490048,977840128],[994598912,1012948992,1026586624,1044936704,1063286784,1075351552,1093701632,1112051712,1125689344,1144039424],[1162371072,1180721152,1192785920,1211136000,1229486080,1243123712,1261473792,1279823872,1293461504],[1313366016,1331716096,1343780864,1362130944,1380481024,1394118656,1412468736],[1430806528,1449156608,1461221376,1479571456,1497921536,1511559168,1529909248],[1546674176,1565024256,1583374336,1593866240,1612216320,1630566400,1648916480,1660981248,1679331328,1697681408],[1712873472,1731223552,1749573632,1767923712,1778415616,1796765696,1815115776,1833465856],[1845518336,1863868416,1882218496,1900568576,1918918656,1929410560,1947760640,1966110720],[1979736064,1998086144,2016436224,2034786304,2053136384,2063628288,2081978368,2100328448],[2115520512,2130731008,-2145886208,-2127536128,-2109186048,-2090835968],[-2080356352,-2062006272,-2043656192,-2030018560,-2011668480,-1993318400,-1974968320,-1956618240],[-1946138624,-82294784,-1909438464,-1891088384,-1872738304,-1860673536,-1842323456,-1823973376,-1805623296],[-1793576960,-1778366464,-1760016384,-1741666304,-1723316224,-1704966144,-1691328512,-1672978432,-1654628352],[-1644154880,-1625804800,-1607454720,-1593817088,-1575467008,-1557116928,-1538766848,-1520416768,-1505206272,-1486856192],[-1474809856,-1456459776,-1441249280,-1422899200,-1404549120,-1386199040,-1370988544,-1352638464],[-1340592128,-1322242048,-1307031552,-1288681472,-1270331392,-1251981312,-1236770816,-1218420736],[-1206380544,-1188030464,-1172819968,-1154469888,-1136119808,-1120909312,-1102559232,-1084209152,-1068998656,-1050648576],[-1038608384,-1020258304,-1001908224,-986697728,-968347648,-953137152,-934787072,-916436992,-899653632],[-886040576,-867690496,-852480000,-834129920,-817346560,-798996480,-782213120],[-768600064,-750249984,-735039488,-716689408,-699906048,-681555968,-664772608],[-651165696,-632815616,-617605120,-599255040,-584044544,-565694464,-547344384,-532133888,-513783808,-497000448],[-481820672,-465037312,-446687232,-431476736,-413126656,-397916160,-379566080,-362782720],[-347602944,-329252864,-314042368,-295692288,-280481792,-262131712,-245348352,-228564992],[-213385216,-195035136,-179824640,-161474560,-146264064,-127913984,-111130624,-94347264]
];

// as above, but for each body tilemap
const body = [
  [21495808,39845888,55056384,73406464,85471232,103821312,122171392,140521472,158871552,177221632,186140672,204490752,222840832,241190912,259540992,277891072,289955840,308305920,326656000,345006080,358643712,376993792,395343872,405835776,424185856,442535936,460886016,479236096,488155136,506505216,524855296,543205376,561555456,579905536,598255616,605601792,623951872,642301952,660652032,679002112,697352192,715702272],
  [727736320,746086400,764436480,778074112,796424192,814774272,828411904,846761984,865112064],
  [875597824,893947904,909158400,927508480,945858560,964208640,982558720,1000908800,1009827840,1028177920,1046528000,1064878080,1083228160,1101578240]
];

class BasicView extends Ui.WatchFace {

    // globals
    var debug = false;
    var timer1;
    var timer_timeout = 1000;
    var timer_steps = timer_timeout;
    var current_frame = 15;

    // sensors / status
    var battery = 0;
    var bluetooth = true;

    // time
    var hour = null;
    var minute = null;
    var day = null;
    var day_of_week = null;
    var month_str = null;
    var month = null;

    // layout
    var vert_layout = false;
    var canvas_h = 0;
    var canvas_w = 0;
    var canvas_shape = 0;
    var canvas_rect = false;
    var canvas_circ = false;
    var canvas_semicirc = false;
    var canvas_tall = false;
    var canvas_r240 = false;
    var g_xoffset = 0;
    var g_yoffset = 0;
    var centerpoint = [0,0];
    var xoff = 0;
    var yoff = 0;
    var hand_polygon = [];
    var chapter_offset = 0;

    // settings
    var set_leading_zero = false;

    // fonts
    var f_hands = null;
    var f_hands_31 = null;
    var f_body = null;


    function initialize() {
     Ui.WatchFace.initialize();
    }


    function onLayout(dc) {

      // w,h of canvas
      canvas_w = dc.getWidth();
      canvas_h = dc.getHeight();

      // check the orientation
      if ( canvas_h > (canvas_w*1.2) ) {
        vert_layout = true;
      } else {
        vert_layout = false;
      }

      // let's grab the canvas shape
      var deviceSettings = Sys.getDeviceSettings();
      canvas_shape = deviceSettings.screenShape;

      if (debug) {
        Sys.println(Lang.format("canvas_shape: $1$", [canvas_shape]));
      }

      // find out the type of screen on the device
      canvas_tall = (vert_layout && canvas_shape == SCREEN_SHAPE_RECT) ? true : false;
      canvas_rect = (canvas_shape == SCREEN_SHAPE_RECT && !vert_layout) ? true : false;
      canvas_circ = (canvas_shape == SCREEN_SHAPE_CIRC) ? true : false;
      canvas_semicirc = (canvas_shape == SCREEN_SHAPE_SEMICIRC) ? true : false;
      canvas_r240 =  (canvas_w == 240 && canvas_w == 240) ? true : false;

      // set offsets based on screen type
      // positioning for different screen layouts
      if (canvas_tall) {
        g_yoffset = (-240+205)/2;
        g_xoffset = (-240+148)/2;
        chapter_offset = ((-canvas_h+canvas_w)/2)+10;
      }
      if (canvas_rect) {
        g_yoffset = (-240+148)/2;
        g_xoffset = (-240+205)/2;
        chapter_offset = ((-canvas_w+canvas_h)/2)+10;
      }
      // offset the graphics based on a 240 or 218 screen resolution
      if (canvas_circ) {
        if (canvas_r240) {
          g_xoffset = 0;
          g_yoffset = 0;
          chapter_offset = 10;
        } else {
          g_xoffset = -11;
          g_yoffset = -11;
          chapter_offset = 10;
        }
      }
      if (canvas_semicirc) {
          g_xoffset = -12;
          g_yoffset = -30;
          chapter_offset = ((-canvas_w+canvas_h)/2)+10;
      }

      // load the body font tiles
      f_body = Ui.loadResource(Rez.Fonts.body);

      // load the hand font tiles - we have two sets, 0-29 mins, and 30-59 mins
      f_hands = Ui.loadResource(Rez.Fonts.hands);
      f_hands_31 = Ui.loadResource(Rez.Fonts.hands_31);

      // centerpoint is the middle of the canvas
      centerpoint = [canvas_w/2,canvas_h/2];

      xoff = 12 + g_xoffset;
      yoff = 12 + g_yoffset;

      // the hand polygon corresponds to the Mickey white glove
      // we draw a polygon to 'fill in' Mickey's hollow glove
      hand_polygon = [
        [108+xoff, 15+yoff],
        [113+xoff, 17+yoff],
        [113+xoff, 28+yoff],
        [121+xoff, 33+yoff],
        [122+xoff, 37+yoff],
        [118+xoff, 50+yoff],
        [115+xoff, 56+yoff],
        [109+xoff, 57+yoff],
        [103+xoff, 55+yoff],
        [100+xoff, 39+yoff],
        [103+xoff, 28+yoff],
        [106+xoff, 19+yoff]
      ];
    }


    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }


    //! Update the view
    function onUpdate(dc) {


      // grab time objects
      var clockTime = Sys.getClockTime();
      var date = Time.Gregorian.info(Time.now(),0);

      // define time, day, month variables
      hour = clockTime.hour;
      minute = clockTime.min;
      day = date.day;
      month = date.month;
      day_of_week = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM).day_of_week;
      month_str = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM).month;

      // grab battery
      var stats = Sys.getSystemStats();
      var batteryRaw = stats.battery;
      battery = batteryRaw > batteryRaw.toNumber() ? (batteryRaw + 1).toNumber() : batteryRaw.toNumber();

      // do we have bluetooth?
      var deviceSettings = Sys.getDeviceSettings();
      bluetooth = deviceSettings.phoneConnected;

      // 12-hour support
      if (hour > 12 || hour == 0) {
          if (!deviceSettings.is24Hour)
              {
              if (hour == 0)
                  {
                  hour = 12;
                  }
              else
                  {
                  hour = hour - 12;
                  }
              }
      }


      // w,h of canvas
      var dw = dc.getWidth();
      var dh = dc.getHeight();
      var font;

      // ok, lets clear the screen
      dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_WHITE);
      dc.clear();


      // draw each hour marker around the clock face
      // --------------------------

      var hand_polygon_rot = [];
      var temp_point = [];
      var col = null;

      dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
      var circle_char = 0;

      // draw 12 markers around the perimeter
      for (var u=0; u<12; u++) {

        temp_point = rotatePoint(centerpoint,[dw/2,chapter_offset],(u.toFloat()/12)*360);
        // alternate between char 100 and char 101, which correspond to
        // the two marker circles we draw around the perimeter
        circle_char = u%3 ==0 ? 100 : 101;
        dc.drawText(temp_point[0],temp_point[1]-5,f_body,(circle_char).toChar(),Gfx.TEXT_JUSTIFY_CENTER);

      }




      // draw the body
      // --------------------------

      // draw Mickey's pants
      dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
      drawTiles(body[1],f_body,dc,g_xoffset-10,g_yoffset-5);

      // draw Mickey's shoes
      dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
      drawTiles(body[2],f_body,dc,g_xoffset-10,g_yoffset-5);

      // draw Mickey's body
      dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
      drawTiles(body[0],f_body,dc,g_xoffset-10,g_yoffset-5);



      // draw minute hand
      // --------------------------

      var minute_is = current_frame%60;
      var current_hand;

      // in debug mode, the hand moves every sec
      if (debug) {
        current_hand = hands[minute_is];
      } else {
        current_hand = hands[minute];
        minute_is = minute;
      }

      // switch font based on which half of the watch the hand is ...
      if (minute_is<30) {
        font = f_hands;
      } else {
        font = f_hands_31;
      }


      // rotate the hand_polygon[] hand around the centerpoint[x,y] by (angle)
      for (var u=0; u<hand_polygon.size(); u++) {
        temp_point = rotatePoint(centerpoint,hand_polygon[u],(minute_is.toFloat()/60)*360);
        hand_polygon_rot.add(temp_point);
      }

      // let's draw that polygon for the minute hand
      dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      dc.fillPolygon(hand_polygon_rot);

      // let's draw the actual minute hand tilemap
      dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
      drawTiles(current_hand,font,dc,g_xoffset,g_yoffset);


      // draw hour hand
      // --------------------------

      hand_polygon_rot = [];
      var hour_is = (Math.floor((hour+(minute_is/60.0))*5.0)).toNumber()%60;

      // switch font based on which half of the watch the hand is
      if (hour_is<30) {
        font = f_hands;
      } else {
        font = f_hands_31;
      }

      // rotate the hand_polygon[] hand around the centerpoint[x,y] by (angle)
      for (var u=0; u<hand_polygon.size(); u++) {
        temp_point = rotatePoint(centerpoint,hand_polygon[u],(hour_is.toFloat()/60)*360);
        hand_polygon_rot.add(temp_point);
      }

      // let's draw that polygon for the hour hand
      dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      dc.fillPolygon(hand_polygon_rot);

      // let's draw the actual hour hand tilemap
      dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
      drawTiles(hands[hour_is],font,dc,g_xoffset,g_yoffset);


      // increment the current frame if we are animating in debug mode
      current_frame++;


    }


    // helper function to rotate point[x,y] around origin[x,y] by (angle)
    // --------------------------

    function rotatePoint(origin, point, angle) {

      var radians = angle * Math.PI / 180.0;
      var cos = Math.cos(radians);
      var sin = Math.sin(radians);
      var dX = point[0] - origin[0];
      var dY = point[1] - origin[1];

      return [ cos * dX - sin * dY + origin[0], sin * dX + cos * dY + origin[1]];

    }


    // pass a tilemap array, and the corresponding font, and draw the tile(s)
    // --------------------------

    function drawTiles(packed_array,font,dc,xoff,yoff) {
      // this offset exists as the tilemaps were off by 12px
      var offset = 12;

      for(var i = 0; i < packed_array.size(); i++)
      {
        var packed_value = packed_array[i];

        var pad = packed_value & 255;
        packed_value >>= 8;
        var ypos = packed_value & 255;
        packed_value >>= 8;
        var xpos = packed_value & 255;
        packed_value >>= 8;
        var char = packed_value & 255;

        dc.drawText(xoff+offset+(xpos.toNumber()),yoff+offset+(ypos.toNumber()),font,(char.toNumber()+32).toChar(),Gfx.TEXT_JUSTIFY_LEFT);
      }

    }


    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }


    // this is our animation loop callback
    function callback1() {

      // redraw the screen
      Ui.requestUpdate();

      // timer not greater than 500ms? then let's start the timer again
      if (timer_steps < 500) {
        timer1 = new Timer.Timer();
        timer1.start(method(:callback1), timer_steps, false );
      } else {
        // timer exists? stop it
        if (timer1) {
          timer1.stop();
        }
      }


    }


    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {

      // let's start our animation loop
      timer1 = new Timer.Timer();
      timer1.start(method(:callback1), timer_steps, false );
    }


    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {

      // bye bye timer
      if (timer1) {
        timer1.stop();
      }

      timer_steps = timer_timeout;


    }


}
