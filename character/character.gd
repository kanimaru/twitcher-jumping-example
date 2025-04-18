extends CharacterBody2D

class_name Character

@onready var display: AnimatedSprite2D = %Display

@export var speed: float = 1.0
@export var max_speed: Vector2 = Vector2(5, 5)
@export var floor_drag: Vector2
@export var air_drag: Vector2
@export var jump_strength: float
@export var jump_amount: int = 1

var direction: float

var walk_threshold: float = 2.0
var run_threshold: float = 4.0

var jumps: int
var jumping: bool

var current_scale: Vector2 
var spawnpoint: Vector2


func _ready() -> void:
	current_scale = display.scale
	spawnpoint = global_position
	

func _process(_delta: float) -> void:
	if jumping:
		display.animation = &"jump"
	elif abs(velocity.x) > run_threshold:
		display.animation = &"run"
	elif abs(velocity.x) > walk_threshold:
		display.animation = &"walk"
	else:
		display.animation = &"idle"
		
	if direction > 0: 
		display.scale.x = current_scale.x 
	elif direction < 0: 
		display.scale.x = current_scale.x * -1
		
	
func _physics_process(delta: float) -> void:
	velocity.x += direction * speed * delta
	if is_zero_approx(direction):
		velocity *= floor_drag
	velocity += ProjectSettings.get_setting("physics/2d/default_gravity_vector")
	velocity = velocity.clamp(-max_speed, max_speed)
	
	if is_on_floor():
		jumps = jump_amount
		jumping = false
	else:
		velocity *= air_drag
	
	if velocity.y > 0:
		velocity += ProjectSettings.get_setting("physics/2d/default_gravity_vector")
		
	if Input.is_action_just_pressed(&"jump") and jumps > 0:
		jumps -= 1 
		jumping = true
		velocity += Vector2.UP * jump_strength
		
	move_and_slide()
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"reset"):
		reset()
		
func reset() -> void:
	global_position = spawnpoint 
	
	
func on_exit_world() -> void:
	reset()
