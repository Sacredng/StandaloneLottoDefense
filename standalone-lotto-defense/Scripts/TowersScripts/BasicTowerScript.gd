extends Node2D

@export var projectile_scene: PackedScene
@export var fire_rate: float = 2.0 # shots per second

var enemies_in_range: Array = []
var cooldown: float = 0.0

@onready var projectiles_parent: Node = get_tree().current_scene.get_node_or_null("Projectiles")

func _ready() -> void:
	if projectile_scene == null:
		push_error("projectile_scene not assigned on " + str(self))
	cooldown = 0.0

func _process(delta: float) -> void:
	cooldown = max(0.0, cooldown - delta)
	# cleanup invalid targets
	for e in enemies_in_range.duplicate():
		if !is_instance_valid(e):
			enemies_in_range.erase(e)

func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("EnemiesGroup"):
		enemies_in_range.append(body)

func _on_area_2d_body_exited(body: Node) -> void:
	if body.is_in_group("EnemiesGroup"):
		enemies_in_range.erase(body)

func _on_shoot_timer_timeout() -> void:
	# If you use a Timer node, this function is called by the Timer signal.
	shoot()

func shoot() -> void:
	if cooldown > 0.0:
		return
	if enemies_in_range.size() == 0:
		return

	var target: Node = null
	for e in enemies_in_range:
		if is_instance_valid(e):
			target = e
			break
	if target == null:
		return

	if projectile_scene == null:
		push_error("projectile_scene not assigned on " + str(self))
		return

	var projectile = projectile_scene.instantiate()

	# set meta BEFORE add_child so projectile._ready() can pick it up
	projectile.set_meta("target", target)

	if projectiles_parent:
		projectiles_parent.add_child(projectile)
	else:
		get_tree().current_scene.add_child(projectile)

	projectile.global_position = global_position

	# typed check using class_name
	if projectile is Projectile:
		projectile.target = target
	# else: meta fallback already set; projectile._ready() will read it

	cooldown = 1.0 / fire_rate
