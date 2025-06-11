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
var score_label: RichTextLabel
var score_label_backdrop: RichTextLabel
var demo_label: RichTextLabel
var demo_label_backdrop: RichTextLabel
var demo_label_container: Node2D

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
	if (player.alive and player.mode == "game"):
		progression+=1
		score.text = "%d" % progression
		score_backdrop.text = "%d" % progression
		projectile_timer.wait_time = 1.0 / (progression + 1)
	
func _enter_tree() -> void:
	player = find_child("Player")
	outline = find_child("Outline")
	score_label = find_child("ScoreLabel")
	score_label_backdrop = find_child("ScoreLabel Backdrop")
	score = find_child("Score")
	score_backdrop = find_child("Score Backdrop")
	demo_label = find_child("Demo")
	demo_label_backdrop = find_child("Demo Backdrop")
	demo_label_container = find_child("DemoLabel Container")
	
	projectiles = find_children("*-Projectile")
	projectile_area = find_child("Projectiles")
	projectile_timer = find_child("ProjectileTimer")

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept")):
		play()

func reset():
	# remove all projectiles
	for child in projectile_area.get_children():
		projectile_area.remove_child(child)
	progression = 0
	counter = 0
	player.reset()
	
func play():
	demo_label_container.visible = false
	reset()
	score_label.text = "[b]Score:[/b]"
	score_label_backdrop.text = "[b]Score:[/b]"
	score.text = "%d" % progression
	score_backdrop.text = "%d" % progression
	player.play()

func _on_demo_timer_timeout() -> void:
	demo_label.visible = !demo_label.visible
	demo_label_backdrop.visible = !demo_label_backdrop.visible


func _on_death_timer_timeout() -> void:
	reset()
