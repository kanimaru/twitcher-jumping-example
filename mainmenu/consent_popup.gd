extends Control

class_name ConsentPopup

@onready var yes: Button = %Yes
@onready var no: Button = %No
@onready var consent: RichTextLabel = %Consent

## Called when the authorization process was succesfull
signal twitch_authorized


func _ready() -> void:
	yes.pressed.connect(_on_yes_pressed)
	no.pressed.connect(_on_no_pressed)
	Twitch.auth.device_code_requested.connect(_on_device_code_requested)
	consent.meta_clicked.connect(_on_meta_clicked)


func _on_meta_clicked(url: String) -> void:
	OS.shell_open(url)
	
	
func _on_device_code_requested(device_code: OAuth.OAuthDeviceCodeResponse) -> void:
	var err = OS.shell_open(device_code.verification_uri)
	if err != OK:
		push_error("Can't open browser cause of: ", error_string(err))
	
	
func _on_yes_pressed() -> void:
	await Twitch.setup()
	print("User authorized")
	var user = await Twitch.get_current_user()
	await Twitch.subscribe_event(TwitchEventsubDefinition.CHANNEL_CHAT_MESSAGE, {
		"broadcaster_user_id": user.id,
		"user_id": user.id
	})
	
	twitch_authorized.emit()
	
	
func _on_no_pressed() -> void:
	hide()
	
	
