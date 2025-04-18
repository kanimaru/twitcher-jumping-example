extends Control

class_name Win

signal restart_pressed

@onready var restart: Button = %Restart


func _ready() -> void:
	restart.pressed.connect(restart_pressed.emit)
