extends StaticBody2D


@onready var shop_area: Area2D = $Area2D
@onready var ui_root: CanvasLayer = $CanvasLayer

@onready var button_off: TextureButton = $CanvasLayer/Control/button_off
@onready var button4: TextureButton = $CanvasLayer/Control/TextureButton4
@onready var button3: TextureButton = $CanvasLayer/Control/TextureButton3
@onready var button2: TextureButton = $CanvasLayer/Control/TextureButton2
@onready var button1: TextureButton = $CanvasLayer/Control/TextureButton1
@onready var button5: TextureButton = $CanvasLayer/Control/TextureButton5


#button1 wood to stone level if 10 stone
#button2 stone to iron lvl if 3 iron ioingots
#button3 iron to urukh iron if 2 urukh iron ingots
#button4 urukh iron to meteorite if 6 meteorite ingot 

var current_player = null

func _ready():
	ui_root.visible = false
	
	button1.pressed.connect(_on_button1_pressed)
	button2.pressed.connect(_on_button2_pressed)
	button3.pressed.connect(_on_button3_pressed)
	button4.pressed.connect(_on_button4_pressed)
	button5.pressed.connect(_on_button5_pressed)
	button_off.pressed.connect(_on_button_off_pressed)
	
func _unhandled_input(event):
	if ui_root.visible and event.is_action_pressed("ui_cancel"):
		close_ui()
		
func open_ui(player):
	current_player = player
	ui_root.visible = true
	player.is_using_shop = true
	player.velocity = Vector2.ZERO

func close_ui():
	if current_player:
		current_player.is_using_shop = false
	current_player = null
	ui_root.visible = false

func _on_button_off_pressed():
	close_ui()

func _on_button1_pressed():
	if not current_player:
		return
	
	# wood -> stone (requires 10 stone)
	if current_player.inventory["stone"] >= 10:
		current_player.inventory["stone"] -= 10
		current_player.equipment_level = "stone"
		print("Upgraded to Stone!")
	else:
		print("Not enough stone!")


func _on_button2_pressed():
	if not current_player:
		return
	
	# stone -> iron (requires 3 iron ingot)
	if current_player.inventory["iron_ingot"] >= 3:
		current_player.inventory["iron_ingot"] -= 3
		current_player.equipment_level = "iron"
		print("Upgraded to Iron!")
	else:
		print("Not enough iron ingots!")


func _on_button3_pressed():
	if not current_player:
		return
	
	# iron -> urukh iron (requires 2 urukh iron ingot)
	if current_player.inventory["urukh_iron_ingot"] >= 2:
		current_player.inventory["urukh_iron-ingot"] -= 2
		current_player.equipment_level = "urukh_iron"
		print("Upgraded to Urukh Iron!")
	else:
		print("Not enough urukh iron ingots!")


func _on_button4_pressed():
	if not current_player:
		return
	
	# urukh iron -> meteorite (requires 6 meteorite ingot)
	if current_player.inventory["meteorite_ingot"] >= 6:
		current_player.inventory["meteorite_ingot"] -= 6
		current_player.equipment_level = "meteorite"
		print("Upgraded to Meteorite!")
	else:
		print("Not enough meteorite ingots!")
func _on_button5_pressed():
	if not current_player:
		return
		
	# check if player has 15 gold (ingots)
	if current_player.inventory.has("gold") and current_player.inventory["gold"] >= 15:
		current_player.inventory["gold"] -= 15
		current_player.equipment_level = "gold"
		
		# update ui after change
		get_tree().call_group("ui", "update_table", current_player.inventory)
		
		print("Upgraded to Gold!")
	else:
		print("Not enough gold ingots!")
