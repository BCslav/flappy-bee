extends CharacterBody2D

signal died

var FLAP_POWER = 335
var debug: bool = false
var alive = true

func flap(): 
	velocity.y -= FLAP_POWER
	
func apply_gravity(delta):
	velocity += get_gravity() * delta

func _physics_process(delta: float) -> void:
	if alive:
		rotation = 0
		if not is_on_floor() and not debug:
			apply_gravity(delta)
		else:
			velocity = Vector2.ZERO
			
			
		if Input.is_action_just_pressed("flap"):
			velocity.y = 0
			flap()
	else:
		apply_gravity(delta)
		rotation -= delta * 4
		
	
	if Input.is_action_just_pressed("debug_stop"):
		debug = not debug
		$CollisionShape2D.set_deferred("disabled", debug)
	
	move_and_slide()
	if alive:
		check_for_pipe_collision()

func check_for_pipe_collision():

	for i in range(get_slide_collision_count()):
		
		var collision_data = get_slide_collision(i)
		var collider = collision_data.get_collider()
		
		if collider and collider.is_in_group("pipes"):
			die()
			return

func die():
	velocity.y = 0
	velocity.y -= FLAP_POWER * 2
	$CollisionShape2D.set_deferred("disabled", true)
	alive = false
	emit_signal("died")
	$DeathSound.play()
