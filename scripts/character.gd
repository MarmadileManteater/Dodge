
extends RigidBody2D
const Direction = preload("res://scripts/direction.gd")

@export var alive = true
@export var mode = "demo"

var speed = 200

var directions_pressed = []

var animated_sprite: AnimatedSprite2D
var death_timer: Timer

func _enter_tree() -> void:
	animated_sprite = find_child("AnimatedSprite2D")
	death_timer = find_child("DeathTimer")

func _input(event: InputEvent) -> void:
	if alive and mode == "game":
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
	if (alive && animated_sprite.animation == "explosion"):
		animated_sprite.animation = "idle_down"
		animated_sprite.play()
	if (alive && len(directions_pressed) == 0):
		animated_sprite.animation = "idle_down"
	var bodies = get_colliding_bodies()
	var projectiles = bodies.filter(func(body: Node2D): return body.name.ends_with("Projectile"))
	if (len(projectiles) != 0) && alive:
		var projectile1: RigidBody2D = projectiles[0]
		# if the collision isn't inside the tree, it must be old
		if (projectile1.is_inside_tree()):
			for projectile in projectiles:
				var body: RigidBody2D = projectile
				body.queue_free()
			# prevents this branch from being called twice in a row
			set_physics_process(false)
			animated_sprite.animation = "explosion"
			alive = false
			if (mode == "demo"):
				death_timer.start()
	rotation = 0
	linear_velocity = Vector2(0, 0)
	if (len(directions_pressed) > 0) && alive:
		animated_sprite.animation = "walk_%s" % Direction.to_english(directions_pressed[0])
		for direction in directions_pressed:
			linear_velocity += Direction.to_vec2(direction, speed)

func reset():
	contact_monitor = true
	death_timer.stop()
	# set position of rigidbody
	PhysicsServer2D.body_set_state(
		get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(Vector2(575.0, 334.0))
	)
	directions_pressed = []
	alive = true
	set_physics_process(true)

func play(given_mode = "game"):
	death_timer.stop()
	mode = given_mode
	reset()

func _on_demo_timer_timeout() -> void:
	if (mode == "demo"):
		directions_pressed = [randi() % 4]
