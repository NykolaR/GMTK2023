extends Node

const BASE_ROOM: PackedScene = preload("res://scenes/gameplay/environment/base_room/base_room.tscn")
const PLAYER: PackedScene = preload("res://scenes/gameplay/health_object/ai_player/ai_player.tscn")
const PLACEABLE_COLOR: Color = Color("00eaff")
const CANT_PLACE_COLOR: Color = Color("ff6200")

@onready var _budget_label: Label = %BudgetValue as Label
@onready var _room_holder: Node3D = $HSplitContainer/SubViewportContainer/Gameplay/RoomHolder as Node3D
@onready var _placed_holder: Node3D = $HSplitContainer/SubViewportContainer/Gameplay/PlacedHolder as Node3D
@onready var confirm_room_button: Button = %ConfirmButton as Button
@onready var _highlight: Node3D = $HSplitContainer/SubViewportContainer/Gameplay/Highlight as Node3D
@onready var _highlight_mat: StandardMaterial3D = _highlight.material_override as StandardMaterial3D
@onready var _highlight_area: Area3D = $HSplitContainer/SubViewportContainer/Gameplay/Highlight/BuildCheck as Area3D

@onready var _place_list: ItemList = $HSplitContainer/HBox/VSplitContainer/VBoxContainer/PlacementList as ItemList

var evil_budget: int = 500: set = set_evil_budget
# is currently able to place new items
var placing: bool = false
var highlighted_floor: Node3D = null: set = set_highlighted_floor

var occupied_floors: Array[Node3D] = []

func _ready() -> void:
	Helper.cube_highlighted.connect(cube_highlighted)
	Helper.cube_dehighlighted.connect(cube_dehighlighted)
	set_process_input(false)
	constructing_new_room()
	#bake_navigation()


func _input(event: InputEvent) -> void:
	if highlighted_floor and (not (occupied_floors.has(highlighted_floor) or _highlight_area.get_overlapping_areas().size() > 0)) and event is InputEventMouseButton:
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var selected: Array = _place_list.get_selected_items()
			if selected.size() > 0:
				var ind: int = selected[0]
				if evil_budget >= Craftables.prices[ind]:
					evil_budget -= Craftables.prices[ind]
					var place: Node3D = Craftables.scenes[ind].instantiate()
					_placed_holder.add_child(place)
					place.global_position = highlighted_floor.global_position + Vector3(0.0, 0.5, 0.0)
					occupied_floors.append(highlighted_floor)
					if Craftables.floor_replace[ind]:
						highlighted_floor.hide()


func constructing_new_room() -> void:
	for child in _room_holder.get_children():
		child.queue_free()
	for child in _placed_holder.get_children():
		child.queue_free()
	
	var nroom: Node3D = BASE_ROOM.instantiate()
	placing = true
	set_process_input(true)
	_room_holder.add_child(nroom)
	_placed_holder.process_mode = Node.PROCESS_MODE_DISABLED


func bake_navigation() -> void:
	$HSplitContainer/SubViewportContainer/Gameplay/NavigationRegion3D.bake_navigation_mesh(false)


func cube_highlighted(position: Vector3, floor: Node3D) -> void:
	highlighted_floor = floor

func cube_dehighlighted(position: Vector3, floor: Node3D) -> void:
	if highlighted_floor == floor:
		highlighted_floor = null


func set_highlighted_floor(new: Node3D) -> void:
	if not placing:
		highlighted_floor = null
	else:
		highlighted_floor = new
	if highlighted_floor:
		_highlight.global_position = highlighted_floor.global_position + Vector3.UP
		await get_tree().physics_frame
		# maybe yield 1 frame?
		if occupied_floors.has(highlighted_floor) or _highlight_area.get_overlapping_areas().size() > 0:
			_highlight_mat.emission = CANT_PLACE_COLOR
		else:
			_highlight_mat.emission = PLACEABLE_COLOR
		_highlight.show()
	else:
		_highlight.hide()


func set_evil_budget(new: int) -> void:
	evil_budget = new
	_budget_label.text = "$" + str(evil_budget)


func _on_confirm_button_pressed() -> void:
	# spawn player, begin room sequence
	set_process_input(false)
	placing = false
	bake_navigation()
	_placed_holder.process_mode = Node.PROCESS_MODE_INHERIT
	var np: Node3D = PLAYER.instantiate()
	np.position = Vector3(0, 0, 4)
	_room_holder.add_child(np)
	Helper.enemy_count_check()
	get_tree().create_timer(0.5).timeout.connect(get_tree().call_group.bind("enemy", "set_physics_process", true))


func _on_progress_area_body_entered(body:Node3D) -> void:
	print("AI progressed")

