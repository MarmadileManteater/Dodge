extends Node2D
const Pointer = preload("res://scripts/pointer.gd")

@export var pointer: Pointer


func _enter_tree() -> void:
	pointer = find_child("Pointer")
