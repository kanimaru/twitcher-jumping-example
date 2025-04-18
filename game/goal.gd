extends Area2D

@export var map: Map


func _ready() -> void:
	body_entered.connect(_on_goal_reached)
	
	
func _on_goal_reached(node: Node) -> void:
	map.exited.emit()
