extends Node2D

@export var pipe_scene: PackedScene

func _ready() -> void:
	$PlayArea/Bee/Player.position = $PlayArea/Bee/StartPosition.position

#pipe logic
func _on_pipe_timer_timeout() -> void:
	var new_pipes = pipe_scene.instantiate()
	var start_position = $PlayArea/Pipes/StartPosition.position
	start_position.y = start_position.y + randf_range(-150,150)
	var screen_width = get_viewport_rect().size.x
	new_pipes.global_position = Vector2(screen_width + 100, start_position.y)
	
	$PlayArea/Pipes/PipeContainer.add_child(new_pipes)
