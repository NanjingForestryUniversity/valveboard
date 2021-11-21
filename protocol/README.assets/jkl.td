Header (
	company("EMA Design Automation") 
	product("TimingDesigner") 
	rev("9.2") 
	file("c:/users/guoyr/desktop/jkl.td") 
	date("11/09/2021") time("19:23") 
	format("9.0") 
	baseScale(1000.000000) 
	zoomFactor("2.73189e-005") 
	zoomBegin(0) 
	zoomEnd(1.47911e+007) 
	nameFrameWidth(120) 
	simHDL(Verilog) 
	simDelayMechanism(Transport) 
	nextID(89) 
	TimingAnalysisMethod(51) 
	SDCVersion(0) 
	
	generalPrintParams( "printer,,,portrait,svg,Letter,default,600,100,mm,color,scaleable,")
	diagramPrintParams( "0,2,0,1.4762e+007,true,false,1,1,true,false,false,true,all,specified")
	spreadsheetPrintParams( "0,2147483647,true,false,1,true,all")
	)
tclPreferences (UseAboveSixtyFiveNm UseAlteraFastTimingModel 
	UseActelMaxTimingModel UseTimingPath UseArrivalTime )
HDLHeader( 
	hdlFile("") 
	checkConstraints(true) 
	comment("") 
	checkTimeout(never) 
	
	command( name("jkl") cmdType(null) ))
DefaultLabel(
	delay(showNameString,"") 
	constraint(showNameString,"") 
	guarantee(showNameString,"") 
	measure(showMeasure,"") 
	store(showNameString,"") 
	wait(showNameString,"") 
	end(showNameString,"") 
	boundary(showIncrement,"") 
	loop(showNameString,"") 
	waveform(showSkip,"","") 
	specifiedclock(showSkip,"","") 
	derivedclock(showSkip,"","") 
	simwaveform(showSkip,"","") 
	bus(showValue,"","H") 
	)
DiagramStyle (
	waveformFont(winFont("Arial",90) qtFont("Arial",9) ) 
	rulerFont(winFont("Arial",90) qtFont("Arial",9) ) 
	relationshipFont(winFont("Arial",90) qtFont("Arial",9) ) 
	labelFont(winFont("Arial",90) qtFont("Arial",9) ) 
	annotationFont(winFont("Arial",80) qtFont("Arial",8) ) 
	slotHeight("11") 
	edgeHeight("11") 
	edgeGrade("1.96261") 
	inputPenStyle(0) 
	outputPenStyle(0) 
	inoutPenStyle(0) 
	internalPenStyle(0) 
	vRelationshipPenStyle(0) 
	hRelationshipPenStyle(0) 
	inputPenColor(3) 
	outputPenColor(3) 
	inoutPenColor(3) 
	internalPenColor(3) 
	wavePenWidth("0") 
	relationshipPenWidth("0") 
	wavesOnTop 
	relationshipsOnTop 
	annotationsOnTop 
	showSlopedEdges 
	edgeDisplayType(Uncertainty) 
	)
Clock ( objectID(3) name("SCLK") minheight("0") periodScale(1000.000) period(1000.000000) dutyCycle(50.000000) 
	hdl( direction(output) ) label(showDefault,"","H") )
Waveform ( objectID(2) name("SEN") minheight("0") edges(
	(low,0.000,0.000,L), 
	(high,2500000.000,2500000.000), 
	(low,8500000.000,8500000.000), 
	(high,13500000.000,13500000.000), 
	(blank,14836100.000,14836100.000)) 
	hdl( direction(output) ) label(showDefault,"","H") )
Waveform ( objectID(10) name("SDATA") minheight("0") edges(
	(invalid,0.000,0.000,L), 
	(valid,2750000.000,2750000.000,label(showText,"V0","") ), 
	(invalid,3250000.000,3250000.000,label(showDefault,"V_1","") ), 
	(valid,3750000.000,3750000.000,label(showText,"V1","") ), 
	(invalid,4250000.000,4250000.000,label(showDefault,"V_3","") ), 
	(valid,4750000.000,4750000.000,label(showText,"V2","") ), 
	(invalid,5250000.000,5250000.000), 
	(valid,5750000.000,5750000.000,label(showText,"V3","") ), 
	(invalid,6250000.000,6250000.000), 
	(valid,6750000.000,6750000.000,label(showText,"Vn-2","") ), 
	(invalid,7250000.000,7250000.000), 
	(valid,7750000.000,7750000.000,label(showText,"Vn-1","") ), 
	(invalid,8250000.000,8250000.000), 
	(valid,13750000.000,13750000.000,label(showText,"V_0","") ), 
	(invalid,14250000.000,14250000.000), 
	(valid,14711900.000,14711900.000), 
	(blank,14772000.000,14772000.000)) 
	hdl( direction(output) ) label(showDefault,"","H") )
EndCycleEvent ( objectID(1) name("end") time(14762.000000) showVert hideOnPrinter label(showDefault,"") fromLatestEnd toEarliestBegin  )
BreakEvent ( objectID(6) name("break1") source("SCLK",13) label(showDefault,"") fromLatestEnd toEarliestBegin  )
BreakEvent ( objectID(78) name("break2") source("SCLK",21) label(showDefault,"") fromLatestEnd toEarliestBegin  )
CycleBar ( name(bar) label(showDefault,"") fromLatestEnd toEarliestBegin cycleColor(9) cycleLineStyle(1) showVert showVertAttach showHash lineHoriz  )
BoundaryEvent ( objectID(38) source("SEN",1) cycleBar("bar") showVert label(showText,"frame1") fromLatestEnd toEarliestBegin  )
BoundaryEvent ( objectID(39) source("SEN",2) cycleBar("bar") showVert label(showText,"dummy1") fromLatestEnd toEarliestBegin  )
BoundaryEvent ( objectID(54) source("SEN",3) cycleBar("bar") showVert label(showText,"frame2") fromLatestEnd toEarliestBegin  )
Constraint ( name("t1") value("[250,,750]") comment("t1") 
	instance(objectID(5) source("SEN",1) target("SCLK",6) MarginValue("[250,,250]") label(showComment,"") fromLatestEnd toEarliestBegin bottom  )
	instance(objectID(63) source("SEN",3) target("SCLK",28) MarginValue("[250,,250]") label(showComment,"") fromLatestEnd toEarliestBegin bottom  ))
Constraint ( value("t1") comment("t3") 
	instance(objectID(9) source("SCLK",16) target("SEN",2) MarginValue("[250,,250]") label(showComment,"") fromLatestEnd toEarliestBegin bottom  ))
StoreImage ( name("sample1") value("[1,1,1]") StoreEvent ( objectID(11) name("sample1") source("SCLK",6) targetWave("SCLK") label(showText,"bit[0]") fromLatestEnd toEarliestBegin  )
)
StoreImage ( name("sample2") value("[1,1,1]") StoreEvent ( objectID(12) name("sample2") source("SCLK",8) targetWave("SCLK") label(showText,"bit[1]") fromLatestEnd toEarliestBegin  )
)
StoreImage ( name("sample3") value("[1,1,1]") StoreEvent ( objectID(13) name("sample3") source("SCLK",10) targetWave("SCLK") label(showText,"bit[2]") fromLatestEnd toEarliestBegin  )
)
StoreImage ( name("sample4") value("[1,1,1]") StoreEvent ( objectID(14) name("sample4") source("SCLK",12) targetWave("SCLK") label(showText,"bit[3]") fromLatestEnd toEarliestBegin  )
)
StoreImage ( name("sample5") value("[1,1,1]") StoreEvent ( objectID(15) name("sample5") source("SCLK",14) targetWave("SCLK") label(showText,"bit[n-2]") fromLatestEnd toEarliestBegin  )
)
StoreImage ( name("sample6") value("[1,1,1]") StoreEvent ( objectID(16) name("sample6") source("SCLK",16) targetWave("SCLK") label(showText,"bit[n-1]") fromLatestEnd toEarliestBegin  )
)
Delay ( name("t3") value("[500,,]") 
	instance(objectID(20) source("SDATA",2) target("SDATA",3) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(21) source("SDATA",3) target("SDATA",4) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(22) source("SDATA",4) target("SDATA",5) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(23) source("SDATA",5) target("SDATA",6) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(24) source("SDATA",6) target("SDATA",7) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(25) source("SDATA",7) target("SDATA",8) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(26) source("SDATA",8) target("SDATA",9) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(27) source("SDATA",9) target("SDATA",10) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(28) source("SDATA",10) target("SDATA",11) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(29) source("SDATA",11) target("SDATA",12) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(30) source("SDATA",1) target("SDATA",2) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(59) source("SDATA",13) target("SDATA",14) label(showDefault,"") hide fromLatestBegin toLatestEnd  ))
Delay ( value("[250,250,250]") 
	instance(objectID(33) source("SCLK",5) target("SDATA",1) label(showDefault,"") hide fromLatestBegin toLatestEnd  ))
Delay ( name("t4") value("[0,0,0]") 
	instance(objectID(40) source("SCLK",5) target("SEN",1) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(41) source("SCLK",17) target("SEN",2) label(showDefault,"") hide fromLatestBegin toLatestEnd  )
	instance(objectID(64) source("SCLK",27) target("SEN",3) label(showDefault,"") hide fromLatestBegin toLatestEnd  ))
Delay ( value("[250,250,250]") 
	instance(objectID(69) source("SEN",3) target("SDATA",13) label(showDefault,"") hide fromLatestBegin toLatestEnd  ))
Constraint ( name("t3") value("[5000,,]") comment("> 4 SCLK cycle") 
	instance(objectID(70) source("SEN",2) target("SEN",3) MarginValue("[0,,]") label(showComment,"") fromEarliestBegin toEarliestEnd slot(1)  ))
Constraint ( value("[,,]") comment("n SCLK cycle") 
	instance(objectID(71) source("SEN",1) target("SEN",2) MarginValue("[,,]") label(showComment,"") fromLatestEnd toEarliestBegin bottom  ))
Constraint ( value("[1000,1000,1000]") comment("1 MHz") 
	instance(objectID(74) source("SCLK",18) target("SCLK",20) MarginValue("[0,,0]") label(showComment,"") fromLatestEnd toEarliestBegin bottom  ))
Constraint ( name("t4") value("[,,]") 
	instance(objectID(84) source("SDATA",12) target("SEN",2) MarginValue("[,,]") label(showDefault,"") fromLatestEnd toEarliestBegin bottom  ))
Constraint ( name("t2") value("[,,]") 
	instance(objectID(87) source("SEN",1) target("SDATA",1) MarginValue("[,,]") label(showDefault,"") fromLatestEnd toEarliestBegin bottom  )
	instance(objectID(88) source("SEN",3) target("SDATA",13) MarginValue("[,,]") label(showDefault,"") fromLatestEnd toEarliestBegin bottom  ))
