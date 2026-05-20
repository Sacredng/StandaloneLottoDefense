extends Node

signal wave_started(wave_number)
signal wave_finished(wave_number)

@export var enemy_scene: PackedScene
@export var spawn_point: Node2D
@export var spawn_points: Array[Node2D] = []
@export var enemies_per_wave: int = 5
@export var spawn_delay: float = 0.6
@export var time_between_waves: float = 5.0
@export var auto_start: bool = false

var current_wave: int = 0
var spawning: bool = false

func _ready() -> void:
	# if you only set spawn_point in the inspector, use it as the single spawn point
	if spawn_points.is_empty() and spawn_point:
		spawn_points.append(spawn_point)
	if auto_start:
		start_next_wave()

func start_next_wave() -> void:
	if spawning:
		return
	current_wave += 1
	spawning = true
	emit_signal("wave_started", current_wave)
	# run the spawn loop asynchronously so we can await timers inside
	_spawn_wave_async(enemies_per_wave + (current_wave - 1) * 2)

func _spawn_wave_async(count: int) -> void:
	spawn_wave(count)

func spawn_wave(count: int) -> void:
	# this function uses await inside the loop; it will not block the engine
	var sp_count := spawn_points.size()
	for i in range(count):
		var e = enemy_scene.instantiate()
		if sp_count > 0:
			var sp = spawn_points[i % sp_count]
			if is_instance_valid(sp):
				e.global_position = sp.global_position
			else:
				e.global_position = Vector2.ZERO
		else:
			e.global_position = Vector2.ZERO

		get_tree().current_scene.add_child(e)

		# try to register with GameManager if present
		var gm = get_tree().current_scene.get_node_or_null("GameManager")
		if gm == null:
			gm = get_node_or_null("/root/GameManager")
		if gm and gm.has_method("register_enemy"):
			gm.register_enemy(e)

		await get_tree().create_timer(spawn_delay).timeout

	spawning = false
	emit_signal("wave_finished", current_wave)

	# wait between waves (non-blocking)
	await get_tree().create_timer(time_between_waves).timeout
	# optional: auto-start next wave
	# start_next_wave()
