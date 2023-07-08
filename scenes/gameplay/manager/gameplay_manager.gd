extends Node

@onready var _highlight: Node3D = $HSplitContainer/SubViewportContainer/Gameplay/Highlight as Node3D

var evil_budget: int = 50: set = set_evil_budget
# is currently able to place new items
var placing: bool = false
var highlighted_floor: Node3D = null: set = set_highlighted_floor

func _ready() -> void:
	Helper.cube_highlighted.connect(cube_highlighted)
	Helper.cube_dehighlighted.connect(cube_dehighlighted)
	bake_navigation()


func set_evil_budget(new: int) -> void:
	evil_budget = new


func bake_navigation() -> void:
	$HSplitContainer/SubViewportContainer/Gameplay/NavigationRegion3D.bake_navigation_mesh(false)


func cube_highlighted(position: Vector3, floor: Node3D) -> void:
	_highlight.global_position = position + Vector3.UP
	#floor.get_child(0).hide()


func cube_dehighlighted(position: Vector3, floor: Node3D) -> void:
	pass
	#floor.get_child(0).show()


func set_highlighted_floor(new: Node3D) -> void:
	highlighted_floor = new


