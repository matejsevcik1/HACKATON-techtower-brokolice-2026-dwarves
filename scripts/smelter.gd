extends StaticBody2D


@onready var shop_area: Area2D = $Area2D
@onready var ui_root: CanvasLayer = $CanvasLayer
@onready var button1: TextureButton = $CanvasLayer/Control/Button1
@onready var button2: TextureButton = $CanvasLayer/Control/Button2
@onready var button3: TextureButton = $CanvasLayer/Control/Button3
@onready var buttonoff: TextureButton = $CanvasLayer/Control/button_off
const PRESSED_GREEN = preload("uid://cwpl6jkn5up0f")
const PRESSED_RED = preload("uid://c2ltee0fdjxli")




var current_player = null

func _ready():
	ui_root.visible = false
	
	button1.pressed.connect(_on_button1_pressed)
	button2.pressed.connect(_on_button2_pressed)
	button3.pressed.connect(_on_button3_pressed)
	buttonoff.pressed.connect(_on_button_off_pressed)
	
func _unhandled_input(event):
	if ui_root.visible and event.is_action_pressed("ui_cancel"):
		close_ui()
		
func open_ui(player):
	current_player = player
	ui_root.visible = true
	player.is_using_shop = true
	player.velocity = Vector2.ZERO
	if current_player.inventory.has("iron_ore") and current_player.inventory["iron_ore"] >= 4:
		button1.texture_pressed = PRESSED_GREEN
	else:
		button1.texture_pressed = PRESSED_RED
	if current_player.inventory.has("urukh_iron_ore") and current_player.inventory["urukh_iron_ore"] >= 4:
		button2.texture_pressed = PRESSED_GREEN
	else:
		button2.texture_pressed = PRESSED_RED
	if current_player.inventory.has("meteorite_ore") and current_player.inventory["meteorite_ore"] >= 4:
		button3.texture_pressed = PRESSED_GREEN
	else:
		button3.texture_pressed = PRESSED_RED

func close_ui():
	if current_player:
		current_player.is_using_shop = false
	current_player = null
	ui_root.visible = false

func _on_button1_pressed():
	if not current_player:
		return
	
	# 4 iron ore → 1 iron ingot
	if current_player.inventory.has("iron_ore") and current_player.inventory["iron_ore"] >= 4:
		button1.texture_pressed = PRESSED_GREEN
		current_player.inventory["iron_ore"] -= 4
		current_player.add_ore("iron_ingot", 1)
		
		get_tree().call_group("ui", "update_table", current_player.inventory)
		print("Crafted 1 Iron Ingot")
	else:
		button1.texture_pressed = PRESSED_RED
		print("Not enough iron ore!")


func _on_button2_pressed():
	if not current_player:
		return
	
	# 4 urukh iron ore → 1 urukh iron ingot
	if current_player.inventory.has("urukh_iron_ore") and current_player.inventory["urukh_iron_ore"] >= 4:
		button2.texture_pressed = PRESSED_GREEN
		current_player.inventory["urukh_iron_ore"] -= 4
		current_player.add_ore("urukh_iron_ingot", 1)
		
		get_tree().call_group("ui", "update_table", current_player.inventory)
		print("Crafted 1 Urukh Iron Ingot")
	else:
		button2.texture_pressed = PRESSED_RED
		print("Not enough urukh iron ore!")


func _on_button3_pressed():
	if not current_player:
		return
	
	# 6 meteorite ore → 1 meteorite ingot
	if current_player.inventory.has("meteorite_ore") and current_player.inventory["meteorite_ore"] >= 6:
		button3.texture_pressed = PRESSED_GREEN
		current_player.inventory["meteorite_ore"] -= 6
		current_player.add_ore("meteorite_ingot", 1)
		
		get_tree().call_group("ui", "update_table", current_player.inventory)
		print("Crafted 1 Meteorite Ingot")
	else:
		button3.texture_pressed = PRESSED_RED
		print("Not enough meteorite ore!")
	
func _on_button_off_pressed():
	close_ui()
