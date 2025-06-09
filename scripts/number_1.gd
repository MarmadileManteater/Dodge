extends Node2D

var player: RigidBody2D
var outline: Line2D
var projectiles: Array
var timer: Timer
var counter = 0

func generate_coord_around_viewport():
	return outline.get_point_position(randi() % outline.get_point_count())

func spawn_projectile(projectile: RigidBody2D):
	var new_projectile = projectile.duplicate()
	var position = generate_coord_around_viewport()
	new_projectile.position = position
	new_projectile.rotation = position.direction_to(player.position).angle() - 1
	new_projectile.linear_velocity = position.direction_to(player.position) * 250
	new_projectile.name = "%d-%s" % [ counter, projectile.name ] 
	counter+=1
	add_child(new_projectile)

func _on_timer_timeout() -> void:
	var projectile: RigidBody2D = projectiles[randi() % len(projectiles)]
	spawn_projectile(projectile)

func _enter_tree() -> void:
	player = find_child("Player")
	outline = find_child("Outline")
	
	projectiles = find_children("*-Projectile")
	timer = find_child("ProjectileTimer")
	timer.timeout.connect(_on_timer_timeout)
