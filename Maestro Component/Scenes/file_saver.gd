extends Node
class_name File_Saver

var fileLoader:File_Loader 
var parent:Component_Maestro

func _ready() -> void:
	parent = get_parent()
	fileLoader = parent.fileLoader 

func save_tau_data(filePath:String):
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	if file == null:
		push_error("Could not open .tau file for writing: " + filePath)
		return

	file.store_line("[General]")
	file.store_line("AudioFileName: "+parent.stream.resource_path.get_file())
	file.store_line("AudioLeadIn: "+ str(fileLoader.audioLeadIn))
	file.store_line("")
	file.store_line("[Metadata]")
	file.store_line("Title: "+fileLoader.title)
	file.store_line("Artist: "+fileLoader.artist)
	file.store_line("Creator: "+fileLoader.creator)
	file.store_line("Version: "+fileLoader.version)
	file.store_line("")
	file.store_line("[Difficulty]")
	file.store_line("HpDrainRate: "+str(fileLoader.hpDrainRate))
	file.store_line("HitWindow: "+str(fileLoader.hitWindow))
	file.store_line("")
	file.store_line("[TimingPoints]")
	for tp:Dictionary in fileLoader.timingPoints:
		file.store_line("bpm: "+ str(tp["bpm"])+", "+"time: "+str(tp["time"]))
	file.store_line("")
	file.store_line("[HitObjects]")
	for obj:Dictionary in fileLoader.hitObjects:
		file.store_line(str(obj["start"])+", "+str(obj["end"])+", "+str(obj["type"]))
	
