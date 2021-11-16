extends RayCast
class_name Gun

export(float, 0, 5, 0.5) var shake_magnitude: float = 0 
export(float, 1, 10, 0.5) var gun_dmg: int = 1
export(int, "PET", "PEAD", "PVC", "PEBD", "PP", "PS") var gun_type: int = 0
export var gun_name: String = "gun"

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var audio_shoot: AudioStreamPlayer = $shoot
onready var camera: FPCamera = get_parent().get_node("Camera") as FPCamera

var inDelay: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	print(inDelay)
	if inDelay: return
	
	anim_sprite.frame = 0
	anim_sprite.play("shoot")
	audio_shoot.play()
	
	if (camera): camera.shake(0.25)
	
	var _collider: Node = get_collider()
	
	if is_instance_valid(_collider) and _collider.is_in_group("zombies"):
		deal_damage(_collider)
	
	inDelay = true
	
func deal_damage(enemy: KinematicBody):
	if enemy.enemy_type == gun_type:
		print("> Done damage to " + enemy.to_string())
		enemy.rec_dmg(gun_dmg)
	if enemy.hp <= 0:
		enemy.kill()

func self_destroy():
	queue_free()


func _on_AnimatedSprite_animation_finished() -> void:
	inDelay = false
