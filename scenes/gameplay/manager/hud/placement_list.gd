extends ItemList


func _ready() -> void:
	for i in Craftables.text_names.size():
		add_item("$" + str(Craftables.prices[i]) + ": " + Craftables.text_names[i], null, true)
		set_item_tooltip(i, Craftables.tooltips[i])

