# Projectile.gd
class_name Projectile
extends Area2D

@export var speed: float = 400.0
@export var damage: int = 5

var target: Node = null

func _ready() -> void:
	# If tower used set_meta fallback, pick it up here
	if target == null and has_meta("target"):
		target = get_meta("target")
	print("Projectile ready. Target:", target)

func _process(delta: float) -> void:
	if target == null or !is_instance_valid(target):
		queue_free()
		return
	look_at(target.global_position)
	global_position = global_position.move_toward(target.global_position, speed * delta)
	if global_position.distance_to(target.global_position) < 8.0:
		if target.has_method("take_damage"):
			target.take_damage(damage)
		queue_free()

func _on_area_entered(area: Node) -> void:
	if area.is_in_group("EnemiesGroup"):
		if area.has_method("take_damage"):
			area.take_damage(damage)
		queue_free()
