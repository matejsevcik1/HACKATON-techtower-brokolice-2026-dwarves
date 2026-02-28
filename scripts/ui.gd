extends CanvasLayer

@onready var grid = $Panel/GridContainer
@onready var equipment_label = $Panel2/Label   # ✅ NEW

var player : Node

var item_order = [
	"stone",
	"iron_ore",
	"iron_ingot",
	"urukh_iron_ore",
	"urukh_iron_ingot",
	"meteorite_ore",
	"meteorite_ingot",
	"gold"
]

func _ready():

	print("UI READY")

	player = get_tree().get_first_node_in_group("player")

	if player == null:
		print("ERROR: Player not found in group 'player'")
		return

	player.inventory_changed.connect(update_ui)

	print("Connected to inventory_changed")
	print("Grid children:", grid.get_child_count())

	update_ui(player.inventory)
	update_equipment() # ✅ set it once at start


# ------------------------------------------------ #
# INVENTORY UPDATE
# ------------------------------------------------ #

func update_ui(inventory_data):

	print("---- UI UPDATE ----")

	for i in grid.get_child_count():

		var label = grid.get_child(i)

		if label is Label:

			if i < item_order.size():

				var item_name = item_order[i]
				var value = inventory_data.get(item_name, 0)

				label.text = str(value)

				print("Slot", i, "|", item_name, "=", value)

			else:
				label.text = ""

	print("---- UPDATE END ----")


# ------------------------------------------------ #
# EQUIPMENT UPDATE
# ------------------------------------------------ #

func update_equipment():

	if player == null:
		return

	# If your player script has:
	# @export var equipment_level = "stone"

	var level = player.equipment_level

	equipment_label.text = "Equipment: " + str(level)

	print("Equipment updated:", level)


# OPTIONAL: Call this when equipment changes
func _process(_delta):
	update_equipment()
