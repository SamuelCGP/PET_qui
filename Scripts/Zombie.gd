extends KinematicBody
class_name Enemy

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var raycast: RayCast = $RayCast

var player: Player = null
var dead = false
var inDelay = false

export(float, 0.5, 10, 0.5) var speed: float = 3
export var hp = 3
export var enemy_dmg = 1
export(int, "PET", "PEAD", "PVC", "PEBD", "PP", "PS") var enemy_type = 0

onready var delay: float = anim_player.get_animation("attacking").length

func _ready() -> void:
	anim_player.play("walk")
	add_to_group("zombies")

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player) or dead or inDelay: return
	
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	raycast.cast_to = vec_to_player * 1.5
	
	move_and_slide(vec_to_player * speed)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			deal_damage(coll)

func deal_damage(collided_player: Player) -> void:
	collided_player.rec_dmg(enemy_dmg)
	
	inDelay = true
	
	if collided_player.hp <= 0:
		collided_player.kill()
	
	atk_delay()

func rec_dmg(dmg: int) -> void:
	hp = hp - dmg

func atk_delay():
	anim_player.play("attacking")
	yield(get_tree().create_timer(delay), "timeout")
	anim_player.play("walk")
	inDelay = false

func kill():
	dead = true
	$CollisionShape.disabled = true
	anim_player.play("die")

func set_player(p):
	player = p
