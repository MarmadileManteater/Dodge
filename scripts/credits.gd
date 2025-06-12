extends Node2D

var scrolling_content: Node2D
var is_scrolling = false

func _enter_tree() -> void:
	scrolling_content = find_child("Scrolling Content")

func stop():
	visible = false
	is_scrolling = false

func start():
	visible = true
	is_scrolling = true
	scrolling_content.position[1] = 600

func _physics_process(delta: float) -> void:
	if (is_scrolling):
		if (scrolling_content.position[1] > -3820):
			scrolling_content.position[1] -= 2
		else:
			scrolling_content.position[1] = 600
