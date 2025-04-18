extends Node

@onready var win: Win = %Win
@onready var character: Character = $Character
@onready var map: Map = %Map


func _ready() -> void:
	win.restart_pressed.connect(_on_restart)
	map.exited.connect(_on_exit)


func _on_restart() -> void:
	get_tree().reload_current_scene()


func _on_exit() -> void:
	win.show()
