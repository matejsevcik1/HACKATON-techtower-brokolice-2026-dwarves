extends StaticBody2D

@export var data: LadderData
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if data == null:
		push_error("LadderData not assigned!")
		return
	
	sprite_2d.texture = data.texture


func tp(player: CharacterBody2D) -> void:
	if data == null:
		return
	
	player.global_position = data.target_position
	print("Player teleported to:", data.target_position)
