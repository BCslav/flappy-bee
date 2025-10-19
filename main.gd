extends Node2D

@export var pipe_scene: PackedScene
@onready var player = $PlayArea/Bee/Player

var score = 0
var best_score = 0


func _ready() -> void:
	player.position = $PlayArea/Bee/StartPosition.position
	$UI/Score.hide()
	player.set_physics_process(false)

#pipe logic
func _on_pipe_timer_timeout() -> void:
	var new_pipes = pipe_scene.instantiate()
	var start_position = $PlayArea/Pipes/StartPosition.position
	start_position.y = start_position.y + randf_range(-150,150)
	var screen_width = get_viewport_rect().size.x
	new_pipes.global_position = Vector2(screen_width + 100, start_position.y)
	
	$PlayArea/Pipes/PipeContainer.add_child(new_pipes)
	new_pipes.gate_passed.connect(_on_new_pipes_gate_passed)

func _on_new_pipes_gate_passed():
	score += 1
	$UI/Score/ScoreLabel.text = str(score)
	$CoinSound.play()

func _on_button_pressed() -> void:
	game_start()

func game_start():
	$PlayArea/Pipes/PipeTimer.start()
	player.position = $PlayArea/Bee/StartPosition.position
	player.velocity = Vector2.ZERO
	player.alive = true
	player.set_physics_process(true)
	
	$UI/Score.show()
	$UI/Menu.hide()

func _on_player_died() -> void:
	$PlayArea/Bee/DeathTimer.start()

func _on_death_timer_timeout() -> void:
	game_stop()

func game_stop():
	$PlayArea/Pipes/PipeTimer.stop()
	if score > best_score:
		best_score = score
	$UI/Menu/MenuText.text = "Retry?"
	$UI/Menu/MenuScore.text = "Best: " + str(best_score)
	$UI/Score.hide()
	$UI/Menu.show()
	$UI/Score/ScoreLabel.text = "0"
	score = 0
