extends StaticBody2D

var health: int
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var data: RockData
var category :int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = data.maxHealth
	sprite_2d.texture = data.texture
	category = data.category

func take_damage(amount:int,pick_type:int) -> void:
	if pick_type >= category:
		health -= amount
		print("rock took dmg weeh weeh")
	
	if health <= 0:
		break_rock()

func break_rock() -> void:
	drop_ore()
	queue_free()

func drop_ore() -> void:
	if data.ore_resource == null:
		return

	var ore_scene = preload("res://scenes/ore_pickup.tscn")
	var ore_instance = ore_scene.instantiate()

	ore_instance.ore_data = data.ore_resource
	ore_instance.global_position = global_position

	get_tree().current_scene.add_child(ore_instance)
