extends KinematicBody
class_name Enemy

onready var anim_player: AnimatedSprite3D = $AnimatedSprite3D
onready var raycast: RayCast = $RayCast

signal died

var player: Player = null
var dead = false
var inDelay = false
var active = true

export(float, 0.5, 10, 0.5) var speed: float = 3
export var hp = 3
export var enemy_dmg = 1
export var attack_range : float = 1.5
export(int, "PET", "PEAD", "PVC", "PEBD", "PP", "PS") var enemy_type = 0

onready var nav : Navigation = get_parent().get_parent().get_node("Navigation")
var path := []
var path_node := 0

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var rand : float = rng.randf_range(.3, .7)
	$SpawnTimer.wait_time = rand
	$SpawnTimer.start()
	anim_player.play("walk")
	add_to_group("zombies")
	
	connect("died", get_parent().get_parent(), "on_enemy_killed")

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player) or dead or inDelay or !active: return
	
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	raycast.cast_to = vec_to_player * attack_range
	
#	move_and_slide(vec_to_player * speed)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			deal_damage(coll)
			return
			
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed)

func move_to(target_pos : Vector3):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func deal_damage(collided_player: Player) -> void:
	collided_player.rec_dmg(enemy_dmg)
	
	inDelay = true
	
	if collided_player.hp <= 0:
		collided_player.kill()
	
	atk_delay()

func rec_dmg(dmg: int) -> void:
	hp = hp - dmg

func atk_delay():
	if dead: return
	anim_player.play("attack")
	inDelay = true

func kill():
	dead = true
	$CollisionShape.disabled = true
	anim_player.play("die")
	
	set_physics_process(false)
	$DestroyTimer.start()
	
	if enemy_type == Enums.Types.PET:
		if(randf() >= .6):
			spawn(load("res://Scenes/PEADZombie.tscn"))
			return

	emit_signal("died")
	
func spawn(enemy_to_spawn : PackedScene):
	var instance : Node = enemy_to_spawn.instance()
	instance.transform = transform
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	instance.translation = translation + Vector3(rng.randf_range(-1, 1), 0, rng.randf_range(-1, 1))
	instance.set_player(player)
	get_parent().add_child(instance)

func set_player(p):
	player = p

func _on_Timer_timeout():
	move_to(player.global_transform.origin)


func _on_AnimatedSprite3D_animation_finished():
	if $AnimatedSprite3D.animation == "attack":
		anim_player.play("walk")
		inDelay = false


func _on_DestroyTimer_timeout():
	queue_free()


func _on_SpawnTimer_timeout():
	active = true
