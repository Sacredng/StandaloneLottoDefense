extends Area2D

@export var speed = 400
@export var damage = 5

var target = null

func _process(delta):

	if !is_instance_valid(target):
		queue_free()
		return

	global_position = global_position.move_toward(
		target.global_position,
		speed * delta
	)

	if global_position.distance_to(target.global_position) < 10:
		target.take_damage(damage)
		queue_free()
