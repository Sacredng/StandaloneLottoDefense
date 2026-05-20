extends CharacterBody2D

signal died(enemy)

@export var max_health: int = 10
@export var reward: int = 5

var current_health: int

func _ready():
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		die()

func die() -> void:
	emit_signal("died", self)
	queue_free()

func get_reward() -> int:
	return reward

# call this when enemy reaches the end of the path
func reach_goal() -> void:
	# notify GameManager directly or via signal
	get_tree().current_scene.get_node("GameManager").enemy_reached_goal(self)
