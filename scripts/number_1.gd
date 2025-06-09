extends Node2D
const Player = preload("res://scripts/character.gd")

var player: Player
var outline: Line2D
var projectile_area: Node2D
var projectiles: Array
var projectile_timer: Timer
var counter = 0
var progression = 0
var score: RichTextLabel
var score_backdrop: RichTextLabel

func generate_coord_around_viewport():
	return outline.get_point_position(randi() % outline.get_point_count())

func spawn_projectile(projectile: RigidBody2D):
	var new_projectile = projectile.duplicate()
	var position = generate_coord_around_viewport()
	new_projectile.position = position
	new_projectile.rotation = position.direction_to(player.position).angle() - 1
	new_projectile.linear_velocity = position.direction_to(player.position) * 250
	new_projectile.name = "%d-%s" % [ 
		counter,
		projectile.name
	] 
	counter+=1
	projectile_area.add_child(new_projectile)

func _on_projectile_timer_timeout() -> void:
	var projectile: RigidBody2D = projectiles[randi() % len(projectiles)]
	spawn_projectile(projectile)
	
func _on_progression_timer_timeout() -> void:
	if (player.alive):
		progression+=1
		score.text = "%d" % progression
		score_backdrop.text = "%d" % progression
		projectile_timer.wait_time = 1.0 / (progression + 1)

	
func _enter_tree() -> void:
	player = find_child("Player")
	outline = find_child("Outline")
	score = find_child("Score")
	score_backdrop = find_child("Score Backdrop")
	score.text = "%d" % progression
	score_backdrop.text = "%d" % progression
	
	projectiles = find_children("*-Projectile")
	projectile_area = find_child("Projectiles")
	projectile_timer = find_child("ProjectileTimer")
