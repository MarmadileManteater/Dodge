extends Node2D
const Player = preload("res://scripts/character.gd")
const Menu = preload("res://scripts/menu.gd")
const Pointer = preload("res://scripts/pointer.gd")

var player: Player
var outline: Line2D
var projectile_area: Node2D
var projectiles: Array
var projectile_timer: Timer
var progression_timer: Timer
var counter = 0
var progression = 0
var score: RichTextLabel
var score_backdrop: RichTextLabel
var score_label: RichTextLabel
var score_label_backdrop: RichTextLabel
var demo_label: RichTextLabel
var demo_label_backdrop: RichTextLabel
var demo_label_container: Node2D
var background_music: AudioStreamPlayer2D
var menu: Menu
var volume_range = 13
var bgm_volume = 0
var sfx_volume = 0
var high_scores = [3,3,3]
var new_high_score: Node2D
var bgm_muted = false

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
		projectile_timer.wait_time = 1.0 / (progression + 1
		)
	
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
	new_high_score = find_child("New High Score")
	
	background_music = find_child("Background Music")
	
	menu = find_child("Menu")
	
	projectiles = find_children("*-Projectile")
	projectile_area = find_child("Projectiles")
	projectile_timer = find_child("ProjectileTimer")
	progression_timer = find_child("ProgressionTimer")

func _input(event: InputEvent) -> void:
	if (menu.visible):
		if (menu.pointer.submenu == null):
			if (event.is_action_pressed("ui_accept")):
				if (menu.pointer.cursor_position == Pointer.MenuItem.PLAY):
					play()
					menu.visible = false
				if (menu.pointer.cursor_position == Pointer.MenuItem.OPTIONS):
					menu.toggle_audio_settings()
				if (menu.pointer.cursor_position == Pointer.MenuItem.SCORES):
					menu.set_scores_text(get_scores_text())
					menu.toggle_high_scores()
				if (menu.pointer.cursor_position == Pointer.MenuItem.CREDITS):
					menu.pointer.submenu = "credits"
					menu.credits.start()
					menu.pointer.visible = false
		elif (menu.pointer.submenu == "options"):	
			if (event.is_action_pressed("ui_accept")):
				save_game()
				menu.pointer.submenu = null
				menu.toggle_audio_settings()
				menu.pointer.set_cursor_position(Pointer.MenuItem.OPTIONS)
			if (event.is_action_pressed("ui_left", true)):
				set_volume_relatively(-1)
			if (event.is_action_pressed("ui_right", true)):
				set_volume_relatively(1)
		elif (menu.pointer.submenu == "high_scores"):
			if (event.is_action_pressed("ui_accept")):
				menu.pointer.submenu = null
				menu.toggle_high_scores()
				menu.pointer.set_cursor_position(Pointer.MenuItem.SCORES)
		elif (menu.pointer.submenu == "credits"):
			if (event.is_action_pressed("ui_accept")):
				menu.credits.stop()
				menu.pointer.submenu = null
				menu.pointer.visible = true
				menu.pointer.set_cursor_position(Pointer.MenuItem.CREDITS)
	if (event.is_action_pressed("ui_up")):
		menu.pointer.set_cursor_position_relatively(-1)
	if (event.is_action_pressed("ui_down")):
		menu.pointer.set_cursor_position_relatively(1)

func reset():
	# remove all projectiles
	for child in projectile_area.get_children():
		projectile_area.remove_child(child)
	progression = 0
	projectile_timer.wait_time = 1.0
	counter = 0
	player.reset()
	
func play():
	progression = 0
	progression_timer.stop()
	progression_timer.start()
	new_high_score.visible = false
	if (player.mode == "demo" and !bgm_muted):
		background_music.play()
	demo_label_container.visible = false
	reset()
	score_label.text = "[b]Score:[/b]"
	score_label_backdrop.text = "[b]Score:[/b]"
	score.text = "%d" % progression
	score_backdrop.text = "%d" % progression
	player.play()
	# stream paused is used to determine if the mute is on
	if (!bgm_muted):
		background_music.stop()
		background_music.play()

func _on_demo_timer_timeout() -> void:
	demo_label.visible = !demo_label.visible
	demo_label_backdrop.visible = !demo_label_backdrop.visible

func _on_death_timer_timeout() -> void:
	if (player.mode == "demo"):
		reset()
	else:
		if add_score(progression) > 0:
			new_high_score.visible = true
		save_game()
		menu.set_first_option_text("Restart")
		menu.visible = true
		menu.pointer.set_cursor_position(0)
		
func set_volume_relatively(volume, position = menu.pointer.cursor_position):
	if (position == 0):
		if ((bgm_volume == volume_range and volume > 0) 
		or (bgm_volume == -volume_range and volume < 0)):
			volume = 0
		bgm_volume += volume
		bgm_muted = bgm_volume == -volume_range
		# won't set before music loads
		background_music.stream_paused = bgm_muted
		if (!background_music.playing && !bgm_muted):
			background_music.play()
		background_music.volume_db += volume
		menu.set_bgm_volume_slider(volume * 2)
	if (position == 1):
		if ((sfx_volume == volume_range and volume > 0) 
		or (sfx_volume == -volume_range and volume < 0)):
			volume = 0
		sfx_volume += volume
		player.mute_explosion = sfx_volume == -volume_range
		player.explosion_sound_effect.volume_db += volume
		menu.set_sfx_volume_slider(volume * 2)
	
func add_score(score):
	for i in range(0, len(high_scores)):
		if (high_scores[i] < score):
			high_scores.insert(i, score)
			if (len(high_scores) > 3):
				high_scores.pop_back()
			return 1
	if (len(high_scores) < 3):
		high_scores.append(score)
		return 0
	else:
		return -1
		
func get_scores_text():
	var string = ""
	for i in range(0, len(high_scores)):
		string += "%d. %d\n" % [ i + 1, high_scores[i] ]
	return string

func save_game():
	var save_file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	var save_dict = {
		"high_scores": high_scores,
		"bgm_volume": bgm_volume,
		"sfx_volume": sfx_volume
	}
	save_file.store_string(JSON.stringify(save_dict, "  ", true))

func load_game():
	if not FileAccess.file_exists("user://savegame.json"):
		return
	
	var save_string = FileAccess.get_file_as_string("user://savegame.json")
	
	var save_dict = JSON.new()
	
	if not save_dict.parse(save_string) == OK:
		print("failed to load save data")
		
	for score in save_dict.data["high_scores"]:
		add_score(score)
		
	set_volume_relatively(save_dict.data["bgm_volume"], 0)
	set_volume_relatively(save_dict.data["sfx_volume"], 1)


func _on_menu_tree_entered() -> void:
	load_game()
	if (!bgm_muted):
		background_music.play()
