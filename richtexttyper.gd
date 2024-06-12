class_name RichTextTyper
extends RichTextLabel

@export var typing_speed: float = 20.0
@export var step_size: int = 1
@export var autoplay: bool = false
@export var sounds: Array[AudioStream] = []
var pause_dict: Dictionary = {}

var playing: bool = false
var characters_to_display: float = 0.0
var paused: bool = false
var pause_timer: float = 0.0

@onready var audio: AudioStreamPlayer2D = $audio

var wait_for_parse = false
var parsed_text = ""
var cparsed_text = ""

func strip_bbcode(source:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)

func collect_bbcode(source: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	var matches = regex.search_all(source)
	var collected_bbcode = ""
	for match in matches:
		collected_bbcode += match.get_string()
	return collected_bbcode

func _ready() -> void:
	visible_characters = 0
	if autoplay:
		playing = true

	parsed_text = strip_bbcode(text)
	cparsed_text = collect_bbcode(text)
	var index = 0
	while true:
		var wait_float_index = text.find("<wait_", index)
		if wait_float_index == -1:
			wait_for_parse = false
			break
		var end_index = text.find(">", wait_float_index)
		var wait_time_str = text.substr(wait_float_index + 6, end_index - wait_float_index - 6)
		
		var parsed_wait_float_index = parsed_text.find("<wait_", index)
		var parsed_end_index = parsed_text.find(">", parsed_wait_float_index)
		parsed_text = parsed_text.erase(parsed_wait_float_index, parsed_end_index - parsed_wait_float_index + 1)

		pause_dict[parsed_wait_float_index] = float(wait_time_str)
		text = text.erase(wait_float_index, end_index - wait_float_index + 1)
		index = parsed_wait_float_index
		wait_for_parse = true

func _process(delta: float) -> void:
	if playing and not paused and !wait_for_parse: 
		characters_to_display += typing_speed * delta

		while characters_to_display >= 1.0 and visible_characters < parsed_text.length():
			visible_characters += step_size
			characters_to_display -= 1.0
			if sounds.size() > 0:
				audio.stream = get_random_sound()
				audio.play()

			if visible_characters in pause_dict.keys():
				paused = true
				pause_timer = pause_dict[visible_characters]
				break

	if paused:
		pause_timer -= delta
		if pause_timer <= 0:
			paused = false
			characters_to_display = 0.0


func reset() -> void:
	visible_characters = 0
	characters_to_display = 0.0
	playing = true
	paused = false
	pause_timer = 0.0

func skip() -> void:
	visible_characters = -1
	characters_to_display = 0.0
	playing = false
	paused = false
	pause_timer = 0.0

func get_random_sound() -> AudioStream:
	if sounds.size() == 0:
		return null
	var index = randi() % sounds.size()
	return sounds[index]
