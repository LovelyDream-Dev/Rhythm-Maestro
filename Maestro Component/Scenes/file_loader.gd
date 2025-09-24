extends Node
class_name File_Loader

var mapData:Map_Data
func _ready() -> void:
	mapData = get_parent()

func load_map(folderPath:String):
	mapData.unload_map()
	var dir = DirAccess.open(folderPath)
	if dir == null:
		push_error("Could not open folder: "+folderPath)
		return

	dir.list_dir_begin()
	var fileName = dir.get_next()
	while fileName != "": # if there are no more files, filename will be ""
		if not dir.current_is_dir():
			if fileName.ends_with(".tau"):
				mapData.tauFilePath = folderPath.path_join(fileName)
				load_tau_file(mapData.tauFilePath, folderPath)
		fileName = dir.get_next()
	dir.list_dir_end()
	mapData.mapLoaded = true

func load_tau_file(filePath:String, folderPath:String):
	var file = FileAccess.open(filePath, FileAccess.READ)
	if file == null:
		push_error("Could not open .tau file: "+filePath)
		return

	var inGeneral = false
	var inMetadata = false
	var inDifficulty = false
	var inTimingPoints = false
	var inHitObjects = false
	while not file.eof_reached():
		var line:String = file.get_line().strip_edges()
		if line == "" or line.begins_with("#"): # Skip empty or commented lines
			continue

		if line.begins_with("[") and line.ends_with("]"):
			inHitObjects = (line == "[HitObjects]")
			inTimingPoints = (line == "[TimingPoints]")
			inGeneral = (line == "[General]")
			inMetadata = (line == "[Metadata]")
			inDifficulty = (line == "[Difficulty]")
			continue

		if inGeneral:
			if line.begins_with("AudioFileName:"):
				var parts = line.split(":", false, 1) # split into [ "AudioFileName", " song.mp3" ]
				var audioFilePath = folderPath.path_join(parts[1].strip_edges())
				load_song(audioFilePath)
			elif line.begins_with("AudioLeadIn:"):
				var parts = line.split(":", false, 1) # split into [ "AudioLeadIn", value]
				mapData.audioLeadIn = float(parts[1])

		if inMetadata:
			if line.begins_with("Title:"):
				var parts = line.split(":", false, 1)
				mapData.title = parts[1].strip_edges()
			elif line.begins_with("Artist:"):
				var parts = line.split(":", false, 1)
				mapData.artist = parts[1].strip_edges()
			elif line.begins_with("Creator:"):
				var parts = line.split(":", false, 1)
				mapData.creator = parts[1].strip_edges()
			elif line.begins_with("Version:"):
				var parts = line.split(":", false, 1)
				mapData.version = parts[1].strip_edges()

		if inDifficulty:
			if line.begins_with("HpDrainRate:"):
				var parts = line.split(":", false, 1)
				mapData.hpDrainRate = float(parts[1])
			if line.begins_with("HitWindow:"):
				var parts = line.split(":", false, 1)
				mapData.hitWindow = float(parts[1])

		# Format for timing points in the tau file: "bpm: value, time: value"
		# Format for timing points as a dictionary: {"bpm" : value, "time" : value} 
		if inTimingPoints:
			var parts = line.split(",")
			if parts.size() == 2:
				var timingPoint = {
					"bpm": float(parts[0].substr(4).strip_edges()),
					"time": float(parts[1].substr(5).strip_edges())
				}
				mapData.timingPoints.append(timingPoint)

		# Format for hit objects in the tau file: "Note start, Note end, Note type"
		# Note type 0 is left and note type 1 is right
		# Format for hit objects as a dictionary: {"start" : value, "end" : value, "type": value}
		if inHitObjects:
			var parts = line.split(",")
			if parts.size() == 3:
				var hitObject = {
					"start": float(parts[0].strip_edges()),
					"end": float(parts[1].strip_edges()),
					"type": int(parts[2].strip_edges())
				}
				mapData.hitObjects.append(hitObject)

func load_song(filePath:String):
	var stream = load(filePath)
	if stream is AudioStreamMP3 or stream is AudioStreamOggVorbis:
		mapData.loadedSong = load(filePath)
		mapData.songLength = mapData.loadedSong.get_length()
	else:
		push_error("Failed to load audio: " + filePath + ". File must be .mp3 or .ogg.")
