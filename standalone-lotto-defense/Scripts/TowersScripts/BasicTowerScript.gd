extends Node2D

@export var projectile_scene : PackedScene
var enemies_in_range = []

func _on_area_2d_body_entered(body):
	print("SOMETHING ENTERED")

	if body.is_in_group("EnemiesGroup"):
		print("ENEMY DETECTED")
		enemies_in_range.append(body)

func _on_area_2d_body_exited(body):
	if body.is_in_group("EnemiesGroup"):
		enemies_in_range.erase(body)

func _on_shoot_timer_timeout():
	if enemies_in_range.size() > 0:
		var target = enemies_in_range[0]
		if is_instance_valid(target):
			var projectile = projectile_scene.instantiate()
			get_tree().current_scene.add_child(projectile)
			projectile.global_position = global_position
			projectile.target = target
