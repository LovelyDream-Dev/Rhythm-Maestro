extends AudioStreamPlayer
class_name Component_Maestro

signal WHOLE_BEAT
signal HALF_BEAT
signal QUARTER_BEAT
signal EIGTH_BEAT
signal SIXTEENTH_BEAT

@onready var fileLoader:File_Loader = $MapData/FileLoader
@onready var fileSaver:File_Saver = $MapData/FileSaver
@onready var mapData:Map_Data = $MapData

var currentSongPosition:float
var currentBPM:float

var secondsPerBeat:float
var beatsPerSecond:float

func _process(_delta: float) -> void:
	if !mapData.mapLoaded:
		fileLoader.load_map("res://Maestro Component/TestMap")

	set_song()
	if !self.playing:
		self.play()
	else:
		currentSongPosition = self.get_playback_position()
		timing_points()
		emit_beat_signals()

# --- CUSTOM FUNCTIONS ---
func timing_points():
	if len(mapData.timingPoints) == 0:
		return
	mapData.sort_timing_points()
	for tp in mapData.timingPoints:
		var time = tp["time"]
		var bpm = tp["bpm"]
		if currentSongPosition >= time:
			currentBPM = bpm
			secondsPerBeat = 60.0/currentBPM
			beatsPerSecond = currentBPM/60.0

func set_song():
	if mapData.loadedSong is AudioStream and !self.stream:
		self.stream = mapData.loadedSong

func emit_beat_signals():
	var lastWholeBeat:float = 0
	if (currentSongPosition - lastWholeBeat) > secondsPerBeat:
		lastWholeBeat += secondsPerBeat
		print("1")
