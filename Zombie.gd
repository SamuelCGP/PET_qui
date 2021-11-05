extends KinematicBody
class_name Enemy

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var raycast: RayCast = $RayCast

var player: Player = null
var dead = false
var inDelay = false

export(float, 0.5, 10, 0.5) var speed: float = 3
export var delay = 0.5
export var hp = 3
export var enemy_dmg = 1

func _ready() -> void:
	anim_player.play("walk")
	add_to_group("zombies")

func _physics_process(delta: float) -> void:
	if inDelay:
		return
	if dead:
		return
	if player == null:
		return
	
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	raycast.cast_to = vec_to_player * 1.5
	
	move_and_collide(vec_to_player * speed * delta)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			deal_damage(coll)

func deal_damage(player):
	player.rec_dmg(enemy_dmg)
	inDelay = true
	if player.hp <= 0:
		player.kill()
	atk_delay()

func rec_dmg(dmg):
	hp = hp - dmg

func atk_delay():
	yield(get_tree().create_timer(delay), "timeout")
	inDelay = false

func kill():
	dead = true
	$CollisionShape.disabled = true
	anim_player.play("die")

func set_player(p):
	player = p
