extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(node: Node) -> void:
	node.propagate_call(&"on_exit_world")
