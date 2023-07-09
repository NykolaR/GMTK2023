extends Node


var text_names: Array[String] = [
	"Wall",
	"Hole",
	"H Slider",
	"V Slider",
	"Grunt",
	"Big Grunt"
	# "Grunt Arrow",
	# "Big Grunt Arrow",
]


var prices: Array[int] = [
	25,
	25,
	25,
	25,
	25,
	50
]

var tooltips: Array[String] = [
	"Wall for blocking",
	"Hole for falling",
	"Slider does damage on contact",
	"Slider does damage on contact",
	"Damages enemy on contact",
	"Hugely damages enemy on contact"
]

var scenes: Array[PackedScene] = [
	preload("res://scenes/gameplay/obstacles/dynamic_wall/dynamic_wall_tile.tscn"),
	preload("res://scenes/gameplay/obstacles/hole/dynamic_hole_tile.tscn"),
	preload("res://scenes/gameplay/obstacles/spike/spike_h.tscn"),
	preload("res://scenes/gameplay/obstacles/spike/spike_v.tscn"),
	preload("res://scenes/gameplay/health_object/placeables/melee/grunt_small.tscn"),
	preload("res://scenes/gameplay/health_object/placeables/melee/grunt_big.tscn")
]

var floor_replace: Array[bool] = [
	false,
	true,
	false,
	false,
	false,
	false
]


func get_placeable(index: int) -> Node:
	return null

