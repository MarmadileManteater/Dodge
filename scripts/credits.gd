extends Node2D

#region State
var is_scrolling = false
#endregion
#region Child Nodes
var scrolling_content: Node2D
#endregion
#region Methods
func stop():
	visible = false
	is_scrolling = false

func start():
	visible = true
	is_scrolling = true
	scrolling_content.position[1] = 600
#endregion
func _enter_tree() -> void:
	scrolling_content = find_child("Scrolling Content")

func _physics_process(delta: float) -> void:
	if (is_scrolling):
		if (scrolling_content.position[1] > -4320):
			scrolling_content.position[1] -= 2
		else:
			scrolling_content.position[1] = 600
