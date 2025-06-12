extends AnimatedSprite2D

var original_position: Vector2
@export var cursor_position = 0
@export var min_position = 0
@export var max_position = 4

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
