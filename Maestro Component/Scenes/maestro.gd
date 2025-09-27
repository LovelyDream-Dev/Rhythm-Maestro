extends AudioStreamPlayer
class_name Maestro

signal WHOLE_BEAT

@onready var mapData:MapDataContainer = $MapDataContainer
@onready var metronome:AudioStreamPlayer = $Metronome

@export var metronomeIsOn:bool = false
@export var metronomeLeadInBeats:int
@export var offset:float = 20.0

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
	offset/=1000
	if !mapData.mapLoaded:
		#fileLoader.load_map("res://Maestro Component/TestMap", mapData)
		pass
	else:
		currentBPM = mapData.bpm
		secondsPerBeat = mapData.secondsPerBeat
		beatsPerSecond = mapData.beatsPerSecond
		leadInBeats = mapData.leadInBeats
		leadInTime = mapData.leadInTime
		set_song()
		if !self.playing:
			self.play()
		else:
			currentSongPosition = self.get_playback_position() + offset
			currentBPM = mapData.bpm
			emit_beat_signals()

# --- CUSTOM FUNCTIONS ---

func set_song():
	if mapData.loadedSong is AudioStream and !self.stream:
		self.stream = mapData.loadedSong

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
