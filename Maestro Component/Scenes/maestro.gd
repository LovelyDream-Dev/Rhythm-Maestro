extends AudioStreamPlayer
class_name Maestro

signal WHOLE_BEAT

@onready var mapData:MapDataContainer = $MapDataContainer
@onready var metronome:AudioStreamPlayer = $Metronome
@onready var mutedSong:AudioStreamPlayer = $MutedSong

@export var metronomeIsOn:bool = false
@export var metronomeLeadInBeats:int
@export var offsetInMs:float = 30.0

var offsetInSeconds:float

var currentSongPosition:float
var currentBPM:float

var currentMeasure:int
var beatsPerMeasure:int = 4

var lastWholeBeat:float = -1.0
var currentWholeBeat:float
var nextWholeBeat:float

var secondsPerBeat:float
var beatsPerSecond:float

var leadInTime:float
var leadInBeats:float

func _ready() -> void:
	WHOLE_BEAT.connect(play_metronome)

func _process(_delta: float) -> void:
	offsetInSeconds = offsetInMs/1000
	if !mapData.mapLoaded:
		#fileLoader.load_map("res://Maestro Component/TestMap", mapData)
		pass
	else:
		currentBPM = mapData.bpm
		secondsPerBeat = mapData.secondsPerBeat
		beatsPerSecond = mapData.beatsPerSecond
		leadInBeats = mapData.leadInBeats
		leadInTime = mapData.leadInTime
		if !self.playing:
			self.play()
		else:
			currentSongPosition = mutedSong.get_playback_position()
			currentBPM = mapData.bpm
			emit_beat_signals()

# --- CUSTOM FUNCTIONS ---

func play_or_pause_songs():
	if !mutedSong.playing and !self.playing:
		mutedSong.play(currentSongPosition)
		self.play(currentSongPosition + offsetInSeconds)
	else:
		mutedSong.stream_paused = true
		self.stream_paused = true

func emit_beat_signals():
	currentWholeBeat = beatsPerSecond * currentSongPosition
	while currentSongPosition >= nextWholeBeat:
		var beatIndex = int(round(nextWholeBeat * beatsPerSecond))
		WHOLE_BEAT.emit(beatIndex)
		get_measure(beatIndex)
		nextWholeBeat += secondsPerBeat

func get_measure(beatIndex:int):
	if beatIndex % beatsPerMeasure == 0:
		currentMeasure = floor(currentWholeBeat) / beatsPerMeasure
		

func play_metronome(beatIndex:int):
	if metronomeIsOn:
		var offsetBeat:int = beatIndex - metronomeLeadInBeats
		if offsetBeat > -1:
			if offsetBeat % 4 == 0:
				metronome.pitch_scale += 2.0/12.0
				metronome.play()
			else:
				metronome.pitch_scale = 1.0
				metronome.play()
