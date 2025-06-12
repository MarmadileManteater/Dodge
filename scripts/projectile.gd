extends RigidBody2D

func _on_body_entered(body: Node) -> void:
	if (body.name == "DespawnBox"):
		queue_free()
