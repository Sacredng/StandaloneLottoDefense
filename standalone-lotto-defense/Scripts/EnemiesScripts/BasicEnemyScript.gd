extends CharacterBody2D

@export var max_health = 10

var current_health

func _ready():
	current_health = max_health

func take_damage(amount):
	current_health -= amount

	if current_health <= 0:
		die()

func die():
	queue_free()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		take_damage(5)
