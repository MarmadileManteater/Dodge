
extends RigidBody2D
const Direction = preload("res://scripts/direction.gd")

var speed = 200

var directionsPressed = []

var animatedSprite: AnimatedSprite2D

func _enter_tree() -> void:
	animatedSprite = find_child("AnimatedSprite2D")

func _input(event: InputEvent) -> void:
	for direction in Direction.englishDirections:
		if (event.is_action_pressed("ui_%s" % direction)):
			animatedSprite.animation = "walk_%s" % direction
			directionsPressed.append(
				Direction.toEnum(direction)
			)
		if (event.is_action_released("ui_%s" % direction)):
			animatedSprite.animation = "idle_%s" % direction
			directionsPressed.remove_at(
				directionsPressed.find(
					Direction.toEnum(direction)
				)
			)
		

func _physics_process(delta: float) -> void:
	linear_velocity = Vector2(0, 0)
	if (len(directionsPressed) > 0):
		animatedSprite.animation = "walk_%s" % Direction.toEnglish(directionsPressed[0])
		for direction in directionsPressed:
			linear_velocity += Direction.toVec2(direction, speed)
