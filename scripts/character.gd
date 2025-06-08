
extends RigidBody2D
const Helpers = preload("res://scripts/helpers.gd")

var speed = 200
var motion = Vector2()

var directionsPressed = []

var directions = [ "down", "left", "right", "up" ]

var animatedSprite: AnimatedSprite2D

func _enter_tree() -> void:
	animatedSprite = find_child("AnimatedSprite2D")

func _input(event: InputEvent) -> void:
	for direction in directions:
		if (event.is_action_pressed("ui_%s" % direction)):
			animatedSprite.animation = "walk_%s" % direction
			directionsPressed.append(
				Helpers.englishToDirection(direction)
			)
		if (event.is_action_released("ui_%s" % direction)):
			animatedSprite.animation = "idle_%s" % direction
			directionsPressed.remove_at(
				directionsPressed.find(
					Helpers.englishToDirection(direction)
				)
			)
		

func _physics_process(delta: float) -> void:
	linear_velocity = Vector2(0, 0)
	if (len(directionsPressed) > 0):
		animatedSprite.animation = "walk_%s" % Helpers.directionToEnglish(directionsPressed[0])
		for direction in directionsPressed:
			linear_velocity += Helpers.directionToVec2(direction, speed)
