extends RayCast
class_name Gun

onready var anim_player = $AnimationPlayer

export var gun_dmg: int = 1

func shoot() -> void:
	anim_player.play("shoot")
	var coll = get_collider()
	if is_colliding() and coll.has_method("kill"):
		deal_damage(coll)

func deal_damage(enemy: Enemy):
	enemy.rec_damage(gun_dmg)
	if enemy.hp <= 0:
		enemy.kill()
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()
