extends Node

@export var blocks_per_user: int = 5


@onready var place_command: TwitchCommand = %PlaceCommand
@onready var map: Map = %Map


class UserData extends RefCounted:
	var user: TwitchUser
	var blocks_placed: int
	var blocks: Array[Vector2] = []
	
	
var user_data: Dictionary[String, UserData]


func _ready() -> void:
	place_command.command_received.connect(_on_command_received)
	
	
func get_emote(chat_message: TwitchChatMessage) -> SpriteFrames:
	for fragment: TwitchChatMessage.Fragment in chat_message.message.fragments:
		if fragment.emote:
			return await fragment.emote.get_sprite_frames(TwitchMediaLoader.instance)
	return null
	
	
func _on_command_received(from_username: String, info: TwitchCommandInfo, args: PackedStringArray) -> void:
	var user_data: UserData = user_data.get_or_add(from_username, UserData.new())
	var chat_message: TwitchChatMessage = info.original_message as TwitchChatMessage
	await chat_message.load_emotes_from_fragment(TwitchMediaLoader.instance)
	var color: Color = Color.from_string(chat_message.color, Color.WHITE)
	
	if user_data.blocks_placed >= blocks_per_user: 
		user_data.blocks_placed -= 1
		var block: Vector2 = user_data.blocks.pop_front()
		map.clear_block(block)

	var p1: String
	var p2: String
	var emote: SpriteFrames
	if args.size() == 3:
		p1 = args[0]
		p2 = args[1]
		emote = await get_emote(chat_message)
	if args.size() == 2:
		p1 = args[0]
		p2 = args[1]
	if args.size() == 1:
		p1 = args[0][0]
		p2 = args[0][1]
	
	var pos = map.coordinate_to_position(p1, p2)
	if pos.x == -999 || pos.y == -999: return
	user_data.blocks_placed += 1
	user_data.blocks.append(pos)
	map.place_block(pos, color, emote)
	print(from_username, " placed ", user_data.blocks_placed, " at ", pos)
