extends Node2D


func _on_flicker_timer_timeout() -> void:
	visible = !visible
