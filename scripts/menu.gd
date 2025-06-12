extends Node2D
const Pointer = preload("res://scripts/pointer.gd")

@export var pointer: Pointer


func _enter_tree() -> void:
	pointer = find_child("Pointer")


func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		Input.action_press("ui_accept")
