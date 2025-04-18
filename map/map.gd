extends Node2D

class_name Map

@onready var border: ColorfullTileMapLayer = %Border

@export var start: Vector2 = Vector2(5, 16)

signal exited

var emote_cache : Dictionary[Vector2i, AnimatedSprite2D] = {}


func place_block(pos: Vector2i, color: Color, emote: SpriteFrames) -> void:
	pos.x += start.x
	pos.y = start.y - pos.y
	if border.get_cell_tile_data(pos):
		erase_cell(pos)
	else:
		border.colorize(pos, color)
		border.set_cell(pos, 1, Vector2(0, 0))
		show_emote(pos, emote)
		
	border.notify_runtime_tile_data_update()


func clear_block(pos: Vector2i) -> void:
	pos.x += start.x
	pos.y = start.y - pos.y
	erase_cell(pos)
	
	
func erase_cell(pos: Vector2i) -> void:
	border.colorize(pos, Color.TRANSPARENT)
	border.erase_cell(pos)
	var emote: AnimatedSprite2D = emote_cache.get(pos)
	if emote != null:
		emote.queue_free()
		emote_cache.erase(pos)


func show_emote(pos: Vector2i, emote: SpriteFrames) -> void:
	if not emote: return
	var scaler: float = 18.0 / 24.0
	var sprite: AnimatedSprite2D = AnimatedSprite2D.new()
	sprite.sprite_frames = emote
	sprite.animation = &"default"
	sprite.scale = Vector2(scaler, scaler)
	sprite.play()
	sprite.position = border.map_to_local(pos)
	add_child(sprite)
	emote_cache[pos] = sprite


func coordinate_to_position(p1: String, p2: String) -> Vector2:
	var pos: Vector2 = Vector2(-999, -999)
	if p1.is_valid_int():
		pos.x = int(p1) + 1
	else:
		pos.y = name_to_coordinate(p1[0])
		
	if p2.is_valid_int():
		pos.x = int(p2) + 1
	else:
		pos.y = name_to_coordinate(p2[0])
	return pos

	
func name_to_coordinate(char: String) -> int:
	return char.to_upper().unicode_at(0) - 64
