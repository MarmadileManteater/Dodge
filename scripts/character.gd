
extends RigidBody2D
const Direction = preload("res://scripts/direction.gd")

var speed = 200

var directions_pressed = []

var animated_sprite: AnimatedSprite2D

func _enter_tree() -> void:
	animated_sprite = find_child("AnimatedSprite2D")

func _input(event: InputEvent) -> void:
	for direction in Direction.english_directions:
		if (event.is_action_pressed("ui_%s" % direction)):
			animated_sprite.animation = "walk_%s" % direction
			directions_pressed.append(
				Direction.to_enum(direction)
			)
		if (event.is_action_released("ui_%s" % direction)):
			animated_sprite.animation = "idle_%s" % direction
			directions_pressed.remove_at(
				directions_pressed.find(
					Direction.to_enum(direction)
				)
			)

func _physics_process(delta: float) -> void:
	var bodies = get_colliding_bodies()
	var projectiles = bodies.filter(func(body: Node2D): return body.name.ends_with("Projectile"))
	if (len(projectiles) != 0):
		animated_sprite.animation = "explosion"
	rotation = 0
	linear_velocity = Vector2(0, 0)
	if (len(directions_pressed) > 0):
		animated_sprite.animation = "walk_%s" % Direction.to_english(directions_pressed[0])
		for direction in directions_pressed:
			linear_velocity += Direction.to_vec2(direction, speed)
