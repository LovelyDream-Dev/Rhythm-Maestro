extends AudioStreamPlayer2D
class_name Component_Maestro

signal WHOLE_BEAT
signal HALF_BEAT
signal QUARTER_BEAT
signal EIGTH_BEAT
signal SIXTEENTH_BEAT

@onready var fileLoader = $FileLoader

@export var bpm:float

var currentSongPosition:float

var secondsPerBeat:float
var beatsPerSecond:float
var lastWholeBeat:float

# --- CUSTOM FUNCTIONS ---
func set_song(_loadedSong:AudioStreamMP3, _bpm):
	bpm = _bpm
	self.stream = _loadedSong
	currentSongPosition = 0
	lastWholeBeat = 0


func load_song(filePath:String):
	# Don't run if the song isnt an mp3
	if !filePath.ends_with(".mp3"):
		return

	#loadedSong = load(filePath)
