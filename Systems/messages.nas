# MP Carrier Damage and messaging stuff. Falling when hit and sinking and more!

# This file created by realuapilot and phoenix, take this file and do what ever, have fun. But the all the "Origanle" code is created by the origanel developers and is copyrighted under GPL GNU V2 
# But this code is in gpl gnu v2 for compatibility with flightgear. just maintain the same license if you change this file

# Origanle code by: Anders Gidenstam  (anders(at)gidenstam.org) and Vivian Meazza
#  Copyright (C) 2007 - 2012  Anders Gidenstam  (anders(at)gidenstam.org)
#  Copyright (C) 2009  Vivian Meazza
#
#




var fallfast = func{
var g = getprop("/position/altitude-ft");  

  var i = 50; # Carrier falls 50ft when this function is activated
  var j = 65; 
  var alt = getprop("/ai/models/carrier/position/altitude-ft");  # Must be nimitz for this to work. or else itll drop nimitz at KSFO if your vinson or anything else
  var alt2 = 0;
  alt = alt - i;
  alt2 = alt + j;
  setprop("/ai/models/carrier/position/altitude-ft", alt);
  setprop("/ai/models/carrier/position/deck-altitude-ft", alt2);


      	if ( g < 1 ) {
  print("Splashed down continueing sink");
   setprop("/controls/splashed",1); 
  }

    	if ( g < -200 ) {
  print("Carrier under water! hello i am under the water. i can not breath.. (bubble sounds)");
    stopfall();
      setprop("/ai/models/carrier/position/altitude-ft", -200);
  setprop("/ai/models/carrier/position/deck-altitude-ft", -135);
  }

}


var fallslow = func{
  var g = getprop("/position/altitude-ft");  

  var i = 1; # Carrier falls 1ft when this function is activated
  var j = 65; 
  var alt = getprop("/ai/models/carrier/position/altitude-ft");  # Must be nimitz for this to work. or else itll drop nimitz at KSFO if your vinson or anything else
  var alt2 = 0;
  alt = alt - i;
  alt2 = alt + j;
  setprop("/ai/models/carrier/position/altitude-ft", alt);
  setprop("/ai/models/carrier/position/deck-altitude-ft", alt2);




    	if ( g < -200 ) {
  print("Carrier under water! hello i am under the water. i can not breath.. (bubble sounds)");
    stopfall();
      setprop("/ai/models/carrier/position/altitude-ft", -200);
  setprop("/ai/models/carrier/position/deck-altitude-ft", -135);
  }


}




var repair = func{
#carriersys.repair()

setprop("/sim/failure-manager/engines/engine/serviceable",1);
setprop("/sim/failure-manager/engines/engine[1]/serviceable",1);

setprop("/sim/failure-manager/controls/flight/aileron/serviceable",1);
setprop("/sim/failure-manager/controls/flight/elevator/serviceable",1);
setprop("/sim/failure-manager/controls/flight/rudder/serviceable",1);
setprop("/sim/failure-manager/controls/flight/flaps/serviceable",1);
setprop("/sim/failure-manager/controls/flight/speedbrake/serviceable",1);
setprop("/sim/failure-manager/controls/gear/serviceable",1);  # If this is 0 carrier will slowly fall (if in the air) and sink into the water
   setprop("/damage/carrierdead",0); 
      setprop("/controls/splashed",0);  # Used for sounds
   setprop("/controls/falling",0);   # Used for sounds
      setprop("/ai/models/carrier/position/altitude-ft", 0);
  setprop("/ai/models/carrier/position/deck-altitude-ft", 65);
restarttimer();

setprop("/sim/multiplay/chat","Carrier Repaired"); 


}


var mpchat = func{

var a = getprop("/sim/failure-manager/controls/flight/aileron/serviceable");
var b = getprop("/sim/failure-manager/controls/flight/elevator/serviceable");
var c = getprop("/sim/failure-manager/controls/flight/rudder/serviceable");
var d = getprop("/sim/failure-manager/controls/flight/flaps/serviceable");
var e = getprop("/sim/failure-manager/controls/flight/speedbrake/serviceable");
var f = getprop("/sim/failure-manager/controls/gear/serviceable");  # If this is 0 carrier will slowly fall (if in the air) and sink into the water
var g = getprop("/position/altitude-ft");  


	if ( a == 0 ) {
		if ( b == 0 ) {
			if ( c == 0 ) {
        if ( d == 0 ) {
          if ( e == 0 ) {
            if ( f == 0 ) {
setprop("/damage/carrierdead",1); 
              #chat

# lets detect if carrier is airborn or not
	if ( g > 1 ) {
setprop("/sim/multiplay/chat","Mayday Mayday Mayday! Carrier is falling out of the sky! Evacuate!"); 

   stoptimer();
   startfallfast();
   setprop("/controls/falling",1); 
  }
  elsif ( g < 1 ) {
setprop("/sim/multiplay/chat","MAYDAY! Carrier is hit and sinking! Evacuate"); 
   stoptimer();
  stopfall();
  startfallslow();
  }
    


  	   } 
      }
     }
    }
   }
  }
 else {
   setprop("/damage/carrierdead",0); 
   print("Carrier alive");

	}
}


timer_loopTimer = maketimer(1, mpchat);

timer_fallfast = maketimer(0.25, fallfast);
timer_fallslow = maketimer(0.25, fallslow);


setlistener("sim/signals/fdm-initialized", func {
    timer_loopTimer.start();
});
    timer_loopTimer.start();
    # loop body


var restarttimer = func{
    timer_loopTimer.start();
}

var stoptimer = func{
    timer_loopTimer.stop();
}

var startfallfast = func{
    timer_fallfast.start();
}
var startfallslow = func{
    timer_fallslow.start();
}

var stopfall = func{
    timer_fallfast.stop();
    timer_fallslow.stop();
}
