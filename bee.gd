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
		if not is_on_floor() and not debug:
			apply_gravity(delta)
		else:
			velocity = Vector2.ZERO
			
	
		
		if Input.is_action_just_pressed("flap"):
			velocity.y = 0
			flap()
	else:
		apply_gravity(delta)
	
	if Input.is_action_just_pressed("debug_stop"):
		debug = not debug	
	
	move_and_slide()
	if alive:
		check_for_pipe_collision()

func check_for_pipe_collision():
	
	# Loop through all collisions that were recorded this frame.
	for i in range(get_slide_collision_count()):
		
		# 1. Get the RAW collision data object.
		var collision_data = get_slide_collision(i)
		
		# 2. Extract the actual node that was hit (the collider).
		var collider = collision_data.get_collider()
		
		if collider:
				# These two prints are the most important.
				# They will tell us the NAME of what we hit, and if it's in the group.
				print("Collided with: ", collider.name)
				print("Is it in the 'pipes' group? ", collider.is_in_group("pipes"))

		
		# 3. CRITICAL CHECK: Make sure the collider is not null before using it.
		if collider and collider.is_in_group("pipes"):
			die()
			return # Use 'return' here, as it stops the loop and the function.

func die():
	alive = false
	$DeathSound.play()
