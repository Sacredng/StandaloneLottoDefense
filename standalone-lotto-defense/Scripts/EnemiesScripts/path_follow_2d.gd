extends PathFollow2D

@export var speed = 200

func _process(delta):
	progress += speed * delta
