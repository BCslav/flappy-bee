extends Node2D

signal gate_passed
@onready var top_pipe = $TopPipe
@onready var bot_pipe = $BotPipe

var scroll_speed = 300

func _physics_process(delta: float) -> void:
	global_position.x -= scroll_speed * delta
	if global_position.x < -100:
		queue_free()

func _on_score_box_body_entered(_body: Node2D) -> void:
	emit_signal("gate_passed")
