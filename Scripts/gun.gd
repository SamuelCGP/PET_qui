extends RayCast
class_name Gun

export(float, 0, 5, 0.5) var shake_magnitude: float = 0 
export(float, 1, 10, 0.5) var gun_dmg: int = 1
export(int, "PET", "PEAD", "PVC", "PEBD", "PP", "PS") var gun_type: int = 0
export var gun_name: String = "gun"

onready var sprite: Sprite = $Sprite
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var audio_shoot: AudioStreamPlayer = $shoot
onready var camera: FPCamera = get_parent().get_node("Camera") as FPCamera

onready var anim_delay: float = anim_player.get_animation("shoot").length
onready var fire_delay: float = anim_delay

var in_delay: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	if in_delay:
		return

	anim_player.play("shoot")
	audio_shoot.play()
	
	if (camera): camera.shake(0.25)
	
	var _collider: Node = get_collider()
	
	if is_instance_valid(_collider) and _collider.is_in_group("zombies"):
		deal_damage(_collider)
	
	in_delay = true
	gun_delay()
		
func gun_delay():
	yield(get_tree().create_timer(fire_delay), "timeout")
	in_delay = false
	
func deal_damage(enemy: KinematicBody):
	if enemy.enemy_type == gun_type:
		print("> Done damage to " + enemy.to_string())
		enemy.rec_dmg(gun_dmg)
	if enemy.hp <= 0:
		enemy.kill()

func self_destroy():
	queue_free()
