extends Node2D
const Pointer = preload("res://scripts/pointer.gd")

@export var pointer: Pointer
var play_label: RichTextLabel
var play_label_backdrop: RichTextLabel
var audio_settings: TileMapLayer
var music_slider: Sprite2D
var effect_slider: Sprite2D
var high_scores: Node2D
var scores_label: RichTextLabel
var scores_label_backdrop: RichTextLabel

func _enter_tree() -> void:
	pointer = find_child("Pointer")
	play_label = find_child("PlayLabel")
	play_label_backdrop = find_child("PlayLabel Back")
	audio_settings = find_child("Audio Settings")
	music_slider = audio_settings.find_child("Music Slider")
	effect_slider = audio_settings.find_child("Effect Slider")
	high_scores = find_child("High Scores")
	scores_label = high_scores.find_child("Scores Label")
	scores_label_backdrop = high_scores.find_child("Scores Label Backdrop")

func toggle_audio_settings():
	audio_settings.visible = !audio_settings.visible
	if (audio_settings.visible):
		pointer.submenu = "options"
		pointer.set_cursor_position(0)
		
func toggle_high_scores():
	high_scores.visible = !high_scores.visible
	if (high_scores.visible):
		pointer.submenu = "high_scores"
		pointer.visible = false
	else:
		pointer.visible = true

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		Input.action_press("ui_accept")

func set_first_option_text(text = "Play"):
	play_label.text = text
	play_label_backdrop.text = text

func set_scores_text(text):
	scores_label.text = text
	scores_label_backdrop.text = text
	
func set_bgm_volume_slider(relative_position):
	music_slider.position[0] += relative_position
	
func set_sfx_volume_slider(relative_position):
	effect_slider.position[0] += relative_position
	
