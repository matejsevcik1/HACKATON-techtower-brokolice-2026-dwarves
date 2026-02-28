extends Area2D

@export var ore_data: OreData

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	if ore_data == null:
		push_error("OreData not assigned!")
		return

	sprite.texture = ore_data.texture


func _physics_process(_delta: float) -> void:
	print("Ore sending to player:", ore_data.name)
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			print(2)
			body.add_ore(ore_data.name,ore_data.value)
			print("Ore sending to player:", ore_data.name)
			queue_free()
			break
