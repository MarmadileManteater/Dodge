extends AnimatedSprite2D

var original_position: Vector2
@export var cursor_position = 0
@export var min_position = 0
@export var max_position = 4

enum MenuItem {
	PLAY,
	OPTIONS,
	SCORES,
	CREDITS
}

func _enter_tree() -> void:
	original_position = position

func set_cursor_position(given_position):
	if (given_position < min_position):
		given_position = max_position - 1
	given_position = given_position % max_position
	cursor_position = given_position
	position = original_position + Vector2(0, given_position * 92)

func set_cursor_position_relatively(given_position):
	set_cursor_position(cursor_position + given_position)

func _on_play_label_mouse_entered() -> void:
	set_cursor_position(MenuItem.PLAY)

func _on_options_label_mouse_entered() -> void:
	set_cursor_position(MenuItem.OPTIONS)

func _on_scores_label_mouse_entered() -> void:
	set_cursor_position(MenuItem.SCORES)

func _on_credits_label_mouse_entered() -> void:
	set_cursor_position(MenuItem.CREDITS)

func _on_gui_input(event: InputEvent) -> void:
	# allow clicking menu items
	if (event is InputEventMouseButton):
		var event_action = InputEventAction.new()
		event_action.action = "ui_accept"
		event_action.pressed = event.pressed
		Input.parse_input_event(event_action)
