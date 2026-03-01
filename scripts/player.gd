extends CharacterBody2D

const SPEED = 70.0

@onready var hitbox: Area2D = $hitbox
@onready var hitbox_ladder: Area2D = $hitbox_ladder
@onready var hitbox_shops: Area2D = $hitbox_shops
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ui_overlay: CanvasLayer = $Camera2D/ui_overlay

signal inventory_changed(inventory)

var is_using_shop: bool = false
var is_using_ladder: bool = false
var is_minig: bool = false

var last_direction: Vector2 = Vector2.DOWN

@export var equipment_level: String = "wood"
var equipment_level_int := 1



var inventory = {
	"stone": 0,
	"iron_ore": 0,
	"iron_ingot": 0,
	"urukh_iron_ore": 0,
	"urukh_iron_ingot": 0,
	"meteorite_ore": 0,
	"meteorite_ingot": 0,
	"gold": 0
}



func _ready() -> void:
	add_to_group("player")
	ui_overlay.hide()


func add_ore(item: String, amount: int) -> void:
	if inventory.has(item):
		inventory[item] += amount
		inventory_changed.emit(inventory)



# ------------------------------------------------ #
# MINING
# ------------------------------------------------ #

func start_minig() -> void:
	is_minig = true
	velocity = Vector2.ZERO

	var animation_name = "mine" + get_direction_name(last_direction) + equipment_level
	animated_sprite_2d.play(animation_name)

	match equipment_level:
		"stone":
			equipment_level_int = 1
		"iron":
			equipment_level_int = 2
		"urukh_iron":
			equipment_level_int = 3
		"meteorite":
			equipment_level_int = 4

	for body in hitbox.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(1, equipment_level_int)

	await animated_sprite_2d.animation_finished

	is_minig = false




func _physics_process(_delta: float) -> void:

	if Input.is_action_just_pressed("use_pickaxe") and not is_minig:
		start_minig()

	if Input.is_action_just_pressed("use_shop"):
		shop_open()

	if Input.is_action_just_pressed("use_ladder"):
		ladder_tp()

	update_hitbox_position()
	process_movement()

	if not is_minig:
		process_animation()

	move_and_slide()


func process_movement() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED if direction != Vector2.ZERO else Vector2.ZERO


func process_animation() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")

	if direction != Vector2.ZERO:
		last_direction = direction
		play_animation("run", get_direction_name(direction))

	if last_direction.x > 0:
		animated_sprite_2d.flip_h = true
	elif last_direction.x < 0:
		animated_sprite_2d.flip_h = false


func play_animation(prefix: String, suffix: String) -> void:
	animated_sprite_2d.play(prefix + suffix)


func get_direction_name(dir: Vector2) -> String:
	if abs(dir.x) > abs(dir.y):
		return "left"
	return "down" if dir.y > 0 else "up"


func update_hitbox_position() -> void:
	hitbox.position = last_direction.normalized() * 13

var tut_done:bool=false
func ladder_tp() -> void:
	for body in hitbox_ladder.get_overlapping_bodies():
		if body.has_method("tp"):
			body.tp(self)
			if not tut_done:
				ui_overlay.show()


func shop_open() -> void:
	for body in hitbox_shops.get_overlapping_bodies():
		if body.has_method("open_ui"):
			body.open_ui(self)
