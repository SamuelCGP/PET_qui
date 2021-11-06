extends RayCast
class_name Gun

# NodePath é a classe usada pelo Godot no "$" para buscar Nodes.

# Exportar uma variável com esse tipo faz um seletor de Nodes
# bonitinho, muito útil quando o Node que você está buscando
# está fora da sua árvore.
export var camera_path: NodePath

export(float, 0, 5, 0.5) var shake_magnitude: float = 0 
export(float, 1, 10, 0.5) var gun_dmg: int = 1

onready var sprite: Sprite = $CanvasLayer/Sprite
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var audio_shoot: AudioStreamPlayer = $shoot
onready var camera: FPCamera = get_node_or_null(camera_path) as FPCamera

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
	
	var coll = get_collider()
	if is_colliding() and coll.has_method("kill"):
		deal_damage(coll)
	
	in_delay = true
	gun_delay()
		
func gun_delay():
	yield(get_tree().create_timer(fire_delay), "timeout")
	in_delay = false
	
func deal_damage(enemy: Enemy):
	enemy.rec_dmg(gun_dmg)
	if enemy.hp <= 0:
		enemy.kill()
