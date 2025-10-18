extends StaticBody2D

var scroll_speed = 200 

func _physics_process(delta: float) -> void:
	global_position.x -= scroll_speed * delta
	
	if global_position.x < -100:
		queue_free()
