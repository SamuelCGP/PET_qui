extends RayCast
class_name Gun

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var audio_shoot: AudioStreamPlayer = $shoot
onready var anim_delay: float = anim_player.get_animation("shoot").length

export(float, 1, 10, 0.5) var gun_dmg: int = 1
onready var gun_delay: float = anim_delay

var inDelay = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	if inDelay:
		return
	
	anim_player.play("shoot")
	audio_shoot.play()
	var coll = get_collider()
	if is_colliding() and coll.has_method("kill"):
		deal_damage(coll)
		
	inDelay = true
	gun_delay()
		
func gun_delay():
	yield(get_tree().create_timer(gun_delay), "timeout")
	inDelay = false
	
func deal_damage(enemy: Enemy):
	enemy.rec_damage(gun_dmg)
	if enemy.hp <= 0:
		enemy.kill()
