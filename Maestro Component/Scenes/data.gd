extends Node
class_name Map_Data

var mapLoaded:bool = false

var tauFilePath:String

var loadedSong:AudioStream
var songLength:float
var audioLeadIn:float

var hitObjects:Array = []
var timingPoints:Array = []

var title:String
var artist:String
var creator:String
var version:String

var hpDrainRate:float
var hitWindow:float

func unload_map():
	mapLoaded = false
	tauFilePath = ""
	loadedSong = null
	songLength = 0.0
	audioLeadIn = 0.0
	title = ""
	artist = ""
	creator = ""
	version = ""
	hpDrainRate = 0.0
	hitWindow = 0.0
	hitObjects.clear()
	timingPoints.clear()

func sort_timing_points():
	timingPoints.sort_custom(func(a,b): 
		if a["time"] < b["time"]:
			return -1
		elif a["time"] > b["time"]:
			return 1
		else:
			return 0
)

func sort_hit_objects():
	hitObjects.sort_custom(func(a,b): 
		if a["start"] < b["start"]:
			return -1
		elif a["start"] > b["start"]:
			return 1
		else:
			return 0
)
