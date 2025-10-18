extends StaticBody2D

var gap_size = 750.0
var scroll_speed = 200

@onready var top_pipe_sprite = $TopPipeSprite
@onready var top_pipe_collision_box1 = $TopPipeCollisionBox1
@onready var top_pipe_collision_box2 = $TopPipeCollisionBox2
@onready var bot_pipe_sprite = $BotPipeSprite
@onready var bot_pipe_collision_box1 = $BotPipeCollisionBox1
@onready var bot_pipe_collision_box2 = $BotPipeCollisionBox2

func _ready():
	bot_pipe_sprite.position.y = gap_size / 2
	bot_pipe_collision_box1.position.y = gap_size / 2
	bot_pipe_collision_box2.position.y = gap_size / 2
	
	top_pipe_sprite.position.y = -gap_size / 2
	top_pipe_collision_box1.position.y = -gap_size / 2
	top_pipe_collision_box2.position.y = -gap_size / 2

func _physics_process(delta: float) -> void:
	global_position.x -= scroll_speed * delta
	
	if global_position.x < -100:
		queue_free()
