extends AudioStreamPlayer2D
class_name Component_Maestro

signal WHOLE_BEAT
signal HALF_BEAT
signal QUARTER_BEAT
signal EIGTH_BEAT
signal SIXTEENTH_BEAT

@onready var fileLoader = $FileLoader

var currentSongPosition:float
var currentBPM:float

var secondsPerBeat:float
var beatsPerSecond:float
var lastWholeBeat:float

# --- CUSTOM FUNCTIONS ---
func timing_points():
	if len(fileLoader.timingPoints) == 0:
		return
	fileLoader.sort_timing_points()
	for tp in fileLoader.timingPoints:
		var time = tp["time"]
		var bpm = tp["bpm"]
		if currentSongPosition >= time:
			currentBPM = bpm

func _process(_delta: float) -> void:
	if self.playing:
		currentSongPosition = self.get_playback_position()
		timing_points()
