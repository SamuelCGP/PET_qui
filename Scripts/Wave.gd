extends Node
class_name Wave

export var PET : int = 0
export var PEAD : int = 0
export var PVC : int = 0
export var PEBD : int = 0
export var PP : int = 0
export var PS : int = 0

func get_enemy_amount() -> int:
	return PET + PEBD + PEAD + PVC + PP + PS
