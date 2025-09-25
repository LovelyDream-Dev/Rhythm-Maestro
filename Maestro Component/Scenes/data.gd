extends Node
class_name Map_Data

var parent:Component_Maestro

var mapLoaded:bool = false

var tauFilePath:String

var bpm:float
var secondsPerBeat:float
var beatsPerSecond:float

var loadedSong:AudioStream
var songLength:float
var leadInBeats:float
var leadInTime:float

var hitObjects:Array = []
var timingPoints:Array = []

var title:String
var artist:String
var creator:String
var version:String

var hpDrainRate:float
var hitWindow:float

func _ready() -> void:
	parent = get_parent()

func _process(_delta: float) -> void:
	timing_points()

func timing_points():
	if len(timingPoints) == 0:
		return
	sort_timing_points()
	for tp in timingPoints:
		var time = tp["time"]
		var _bpm = tp["bpm"]
		if parent.get_playback_position() >= time:
			bpm = _bpm
			secondsPerBeat = 60.0/_bpm
			beatsPerSecond = _bpm/60.0
			leadInTime = beatsPerSecond * leadInBeats

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

func unload_map():
	mapLoaded = false
	tauFilePath = ""
	loadedSong = null
	songLength = 0.0
	leadInBeats = 0.0
	leadInTime = 0.0
	title = ""
	artist = ""
	creator = ""
	version = ""
	hpDrainRate = 0.0
	hitWindow = 0.0
	hitObjects.clear()
	timingPoints.clear()
