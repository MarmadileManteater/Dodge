
extends RigidBody2D
#region Imports
const Direction = preload("res://scripts/direction.gd")
#endregion
#region  State
@export var alive = true
@export var mode = "demo"
@export var mute_explosion = false
var speed = 200
var directions_pressed = []
#endregion
#region Child Nodes
@export var explosion_sound_effect: AudioStreamPlayer2D
var animated_sprite: AnimatedSprite2D
var death_timer: Timer
#endregion
#region Methods
func reset():
	if (alive):
		# reset animation when alive
		animated_sprite.animation = "idle_down"
		animated_sprite.play()
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
#endregion
#region Signals
func _on_demo_timer_timeout() -> void:
	if (mode == "demo"):
		directions_pressed = [randi() % 4]
#endregion

func _enter_tree() -> void:
	animated_sprite = find_child("AnimatedSprite2D")
	death_timer = find_child("DeathTimer")
	explosion_sound_effect = find_child("Explosion")

func _input(event: InputEvent) -> void:
	if alive and mode == "game":
		for direction in Direction.english_directions:
			if (event.is_action_pressed("ui_%s" % direction)):
				animated_sprite.animation = "walk_%s" % direction
				var enum_direction = Direction.to_enum(direction)
				if directions_pressed.find(enum_direction) == -1:
					directions_pressed.append(
						enum_direction
					)
			if (event.is_action_released("ui_%s" % direction)):
				animated_sprite.animation = "idle_%s" % direction
				var enum_direction = Direction.to_enum(direction)
				directions_pressed.remove_at(
					directions_pressed.find(
						Direction.to_enum(direction)
					)
				)

func _physics_process(delta: float) -> void:
	if (alive && animated_sprite.animation == "explosion"):
		animated_sprite.animation = "idle_down"
		animated_sprite.play()
	var bodies = get_colliding_bodies()
	var projectiles = bodies.filter(func(body: Node2D): return body.name.ends_with("Projectile") && body.is_inside_tree())
	if (len(projectiles) != 0) && alive:
		for projectile in projectiles:
			var body: RigidBody2D = projectile
			body.queue_free()
		# prevent collisions after the first one
		set_physics_process(false)
		animated_sprite.animation = "explosion"
		if (!mute_explosion):
			explosion_sound_effect.play()
		alive = false
		if (mode == "game"):
			death_timer.wait_time = 1
		# use a timer to restart or show the menu
		death_timer.start()
	rotation = 0
	linear_velocity = Vector2(0, 0)
	if (len(directions_pressed) > 0) && alive:
		animated_sprite.animation = "walk_%s" % Direction.to_english(directions_pressed[0])
		for direction in directions_pressed:
			linear_velocity += Direction.to_vec2(direction, speed)
