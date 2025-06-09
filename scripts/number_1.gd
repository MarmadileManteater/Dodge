extends Node2D

var player: RigidBody2D
var projectiles: Array
var timer: Timer
var counter = 0

func generate_coord_around_viewport():
	var viewport_size = get_viewport().size
	var viewport_x = viewport_size[0]
	var viewport_y = viewport_size[1]
	var x = (randi() % (viewport_x + 200) ) - 100
	var y = 0
	if (x < 100 || x > viewport_x):
		print("on edge")
		#y = (randi() % (viewport_y + 200)) - 100
	return Vector2(x, y)
func spawn_projectile(projectile: RigidBody2D):
	var new_projectile = projectile.duplicate()
	# todo set new position
	var position = generate_coord_around_viewport()
	new_projectile.position = position
	print(position.direction_to(player.position).angle())
	new_projectile.rotation = position.direction_to(player.position).angle() - 1
	new_projectile.linear_velocity = position.direction_to(player.position) * 250
	new_projectile.name = "%d-%s" % [ counter, projectile.name ] 
	counter+=1
	add_child(new_projectile)

func _on_timer_timeout() -> void:
	var projectile: RigidBody2D = projectiles[0]
	spawn_projectile(projectile)

func _enter_tree() -> void:
	player = find_child("Player")
	projectiles = find_children("*-Projectile")
	timer = find_child("ProjectileTimer")
	timer.timeout.connect(_on_timer_timeout)
