extends Node

@export var to_control: Node


func _ready() -> void:
	if not "direction" in to_control:
		push_error(to_control, " can't be controlled. Missing: direction")
		set_physics_process(false)


func _physics_process(_delta: float) -> void:
	to_control.direction = Input.get_axis(&"left", &"right")
