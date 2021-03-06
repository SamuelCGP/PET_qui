extends Node
class_name GunController

export var label_path: NodePath

var gun_scenes: Array = [load("res://guns/pet.tscn"), load("res://guns/pead.tscn"), load("res://guns/pvc.tscn"), load("res://guns/pebd.tscn")]
var current_type: int = Enums.Types.PET
var current: Gun = null

signal gun_changed(current_gun_type)

onready var player: KinematicBody = get_parent() as KinematicBody
onready var label: Label = get_node(label_path) as Label

func _ready() -> void:
	create_gun_instance()
	update_gun_name()

func next_gun() -> void:
	var _gun_index = min(current_type + 1, gun_scenes.size() - 1)
	change_gun(_gun_index)

func previous_gun() -> void:
	var _gun_index = max(current_type - 1, 0)
	change_gun(_gun_index)

func change_gun(type: int) -> void:
	if not is_instance_valid(current) or type == current_type: return
	
	current.queue_free()
	
	current_type = type
	create_gun_instance()
	
	update_gun_name()
	emit_signal("gun_changed", current_type)

func create_gun_instance() -> void:
	var _chosen_gun: PackedScene = gun_scenes[current_type]
	var _instance: Gun = _chosen_gun.instance()
	
	player.call_deferred("add_child", _instance)
	
	_instance.add_to_group("gun")
	current = _instance

func update_gun_name() -> void:
	if not is_instance_valid(current): return
	label.text = current.gun_name
