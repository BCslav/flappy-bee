extends Node2D

@export var pipe_scene: PackedScene
@onready var player = $PlayArea/Bee/Player
@onready var pipe_spawn_position = $PlayArea/Pipes/StartPosition
@onready var pipe_container = $PlayArea/Pipes/PipeContainer

enum Difficulty {EASY, MEDIUM, HARD}
#enum Player_State {ALIVE, DEAD}
var selected_difficulty = ""

var score = 0
var best_score = 0
var first_start = true
var start_time_count = 3
var global_speed = 300
var speed_up_increment = 50
var pipe_gap = 0
var pipe_offset = 5

func visible_pipe_speed_up():
	for pipe in pipe_container.get_children():
		pipe.scroll_speed = global_speed
		
func define_random_position():
	var random_start_position: Vector2 = pipe_spawn_position.position
	random_start_position.y = random_start_position.y + randf_range(-175,175)
	print(str(pipe_gap))
	random_start_position.x = get_viewport_rect().size.x + 100
	return random_start_position

func spawn_pipes(random_start_position: Vector2):
	var new_pipes = pipe_scene.instantiate()
	var top_pipe = new_pipes.get_node("TopPipe")
	var bot_pipe = new_pipes.get_node("BotPipe")
	top_pipe.position.y -= pipe_gap
	bot_pipe.position.y += pipe_gap
	
	new_pipes.global_position = random_start_position
	new_pipes.scroll_speed = global_speed
		
	pipe_container.add_child(new_pipes)

	new_pipes.gate_passed.connect(_on_new_pipes_gate_passed)
	
func pipe_initial_spawn(pipes_amount: int):
	for i in range(pipes_amount):
		spawn_pipes(define_random_position())

	var pipe_array_index: int = -1
	var gap = 400
	
	for pipe in pipe_container.get_children():
		pipe_array_index += 1
		pipe.position.x -= gap * pipe_array_index
		pipe.scroll_speed = 0

func _ready() -> void:
	player.position = $PlayArea/Bee/StartPosition.position
	$UI/Score.set_visible(false)
	player.set_physics_process(false)
	pipe_initial_spawn(3)

#pipe logic
func _on_pipe_timer_timeout() -> void:
	spawn_pipes(define_random_position())

func _on_new_pipes_gate_passed():
	score += 1
	$UI/Score/ScoreLabel.text = str(score)
	if score > 0 and score < 100:
		$Sounds/Coin.play()
	else:
		$Sounds/Frog.pitch_scale = score * 0.01
		$Sounds/Frog.play()
		
	if score == 25:
		$Sounds/Nice.play()
		global_speed += speed_up_increment
		visible_pipe_speed_up()
	if score == 50:
		$Sounds/MKImpressive.play()
		global_speed += speed_up_increment
		visible_pipe_speed_up()
	if score == 75:
		$Sounds/Godlike.play()
		global_speed += speed_up_increment
		visible_pipe_speed_up()
	if score == 100:
		$Sounds/NiceCk.play()
		global_speed += speed_up_increment
		visible_pipe_speed_up()
	

func _on_button_pressed() -> void:
	$StartTimer.start()
	$UI/Menu/MenuBg.set_visible(false)
	$UI/Menu/Button.set_visible(false)
	$UI/Menu/MenuScore.set_visible(false)
	$UI/Menu/MenuText.text = str(start_time_count)
	$UI/Menu/MenuText.add_theme_color_override("font_color", Color(0, 0 ,0))

func game_start():	
	#move player, spawn pipes
	$PlayArea/Pipes/PipeTimer.start()
	player.position = $PlayArea/Bee/StartPosition.position
	player.velocity = Vector2.ZERO
	player.alive = true
	player.set_physics_process(true)
	player.get_node("CollisionShape2D").set_deferred("disabled", false)
	
	for pipe in pipe_container.get_children():
		pipe.scroll_speed = global_speed
		
	first_start = false
		
	$UI/Score.set_visible(true)
	$UI/Menu/MenuText.set_visible(false)

func _on_player_died() -> void:
	$PlayArea/Bee/DeathTimer.start()

func _on_death_timer_timeout() -> void:
	for pipe in pipe_container.get_children():
		pipe.scroll_speed = 0
	global_speed = 300
	game_stop()

func game_stop():
	$PlayArea/Pipes/PipeTimer.stop()
	if score > best_score:
		best_score = score
	
	for item in $UI/Menu.get_children():
		item.set_visible(true)
	$UI/Menu/MenuText.remove_theme_color_override("font_color")
	$UI/Menu/MenuText.text = "Retry?"
	$UI/Menu/MenuScore.text = "Score: " + str(score) + "\nBest: " + str(best_score)
	$UI/Score.set_visible(false)
	$UI/Score/ScoreLabel.text = "0"
	score = 0

func _process(_delta: float) -> void:
	if player.alive:
		if 0 > player.position.y or 600 < player.position.y:
			player.die()
	
	### debug
	if Input.is_action_just_pressed("debug_score"):
		score += 1
		$UI/Score/ScoreLabel.text = str(score)

func _on_start_timer_timeout() -> void:
	start_time_count -= 1
	$UI/Menu/MenuText.text = str(start_time_count)
	if start_time_count == 0:
		$StartTimer.stop()
		start_time_count = 3
		game_start()


func _on_hard_pressed() -> void:
	selected_difficulty = Difficulty.HARD
	game_load()
	
func _on_medium_pressed() -> void:
	selected_difficulty = Difficulty.MEDIUM
	game_load()
	
func _on_easy_pressed() -> void:
	selected_difficulty = Difficulty.EASY
	game_load()
	
func game_load():
	difficulty_set()	
	if not first_start:
		for pipe in pipe_container.get_children():
			if pipe.global_position.x < 500:
				pipe.queue_free()
	
	for pipe in pipe_container.get_children():
		var top_pipe = pipe.get_node("TopPipe")
		var bot_pipe = pipe.get_node("BotPipe")
		top_pipe.position.y -= pipe_gap
		bot_pipe.position.y += pipe_gap
		
	$StartTimer.start()
	$UI/Menu/MenuBg.set_visible(false)
	$UI/Menu/HBoxContainer.set_visible(false)
	$UI/Menu/MenuScore.set_visible(false)
	$UI/Menu/MenuText.text = str(start_time_count)
	$UI/Menu/MenuText.add_theme_color_override("font_color", Color(0, 0 ,0))

func difficulty_set():
	if selected_difficulty == Difficulty.EASY:
		pipe_gap += 2 * pipe_offset
	if selected_difficulty == Difficulty.MEDIUM:
		pipe_gap += 1 * pipe_offset
	if selected_difficulty == Difficulty.HARD:
		pipe_gap += 0 * pipe_offset
