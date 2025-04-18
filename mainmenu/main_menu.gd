extends Control

@onready var consent_popup: ConsentPopup = %ConsentPopup

@onready var twitch: Button = %Twitch


func _ready() -> void:
	consent_popup.hide()
	twitch.pressed.connect(_on_twitch_pressed)
	consent_popup.twitch_authorized.connect(_on_authorized)
	
	
func _on_authorized() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
	
	
func _on_twitch_pressed() -> void:
	consent_popup.show()
