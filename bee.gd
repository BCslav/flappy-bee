extends CharacterBody2D

var FLAP_POWER = 350
var debug: bool = false
var alive = true

func flap(): 
	velocity.y -= FLAP_POWER
	
func apply_gravity(delta):
	velocity += get_gravity() * delta

func _physics_process(delta: float) -> void:
	if alive:
		if not is_on_floor():
			apply_gravity(delta)
			check_for_pipe_collision()
		
		if Input.is_action_just_pressed("flap"):
			velocity.y = 0
			flap()
	else:
		apply_gravity(delta)
	
	if Input.is_action_just_pressed("debug_stop"):
		debug = not debug	
	
	move_and_slide()

func check_for_pipe_collision():
	var collision_count = get_slide_collision_count()
	
	if collision_count > 0:
		for i in range(collision_count):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collision and collider.is_in_group("pipes"):
				die()
				break

func die():
	alive = false
	$DeathSound.play()
