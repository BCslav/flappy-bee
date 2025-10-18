extends Node2D

@export var pipe_scene: PackedScene

func _ready():
	$PlayArea/Bee/Player.position = $PlayArea/Bee/StartPosition.position

#pipe logic
func _on_pipe_timer_timeout() -> void:
	var new_pipe = pipe_scene.instantiate()
		
	var pipe_y_position = randf_range(150,450)
	
	var screen_width = get_viewport_rect().size.x
	new_pipe.global_position = Vector2(screen_width + 100, pipe_y_position)
	
	$PlayArea/Pipes/PipeContainer.add_child(new_pipe)
