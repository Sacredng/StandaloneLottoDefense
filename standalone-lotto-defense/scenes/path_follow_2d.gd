extends PathFollow2D

@export var speed = 400

func _process(delta):
	progress += speed * delta
