extends Node
class_name File_Saver

var root:Component_Maestro
var mapData:Map_Data

func _ready() -> void:
	mapData = get_parent()
	root = mapData.get_parent()

func save_tau_data(filePath:String):
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	if file == null:
		push_error("Could not open .tau file for writing: " + filePath)
		return

	file.store_line("[General]")
	file.store_line("AudioFileName: "+root.stream.resource_path.get_file())
	file.store_line("AudioLeadIn: "+ str(mapData.audioLeadIn))
	file.store_line("")
	file.store_line("[Metadata]")
	file.store_line("Title: "+mapData.title)
	file.store_line("Artist: "+mapData.artist)
	file.store_line("Creator: "+mapData.creator)
	file.store_line("Version: "+mapData.version)
	file.store_line("")
	file.store_line("[Difficulty]")
	file.store_line("HpDrainRate: "+str(mapData.hpDrainRate))
	file.store_line("HitWindow: "+str(mapData.hitWindow))
	file.store_line("")
	file.store_line("[TimingPoints]")
	for tp:Dictionary in mapData.timingPoints:
		file.store_line("bpm: "+ str(tp["bpm"])+", "+"time: "+str(tp["time"]))
	file.store_line("")
	file.store_line("[HitObjects]")
	for obj:Dictionary in mapData.hitObjects:
		file.store_line(str(obj["start"])+", "+str(obj["end"])+", "+str(obj["type"]))
	
