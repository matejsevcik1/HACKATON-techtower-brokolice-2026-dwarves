extends CanvasLayer

@onready var grid = $Panel/GridContainer

var player: Node

func _ready() -> void:
	add_to_group("ui")
	player = get_tree().get_first_node_in_group("player")
	update_table(player.inventory if player else {})


# Called from player via call_group
func update_table(inventory_data: Dictionary) -> void:
	var index = 0

	for item in inventory_data.keys():

		if index >= grid.get_child_count():
			break

		var slot = grid.get_child(index)
		var amount = inventory_data[item]

		var icon_path = "res://icons/%s.png" % item

		if not ResourceLoader.exists(icon_path):
			icon_path = "res://icons/%s.png" % item.replace(" ", "_")

		if ResourceLoader.exists(icon_path):
			slot.texture = load(icon_path)

		var label = slot.get_node_or_null("Label")
		if label:
			label.text = str(amount)

		index += 1
