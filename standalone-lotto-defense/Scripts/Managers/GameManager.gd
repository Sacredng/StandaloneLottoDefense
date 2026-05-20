extends Node

@export var starting_money: int = 100
@export var starting_lives: int = 20

var money: int
var lives: int
var wave: int = 0

func _ready():
	money = starting_money
	lives = starting_lives

func register_enemy(enemy: Node) -> void:
	# Called by spawner or when enemy is instanced
	enemy.connect("died", Callable(self, "_on_enemy_died"))

func _on_enemy_died(enemy):
	if enemy.has_method("get_reward"):
		money += enemy.get_reward()
	# update UI here or emit a signal
	emit_signal("money_changed", money)

func enemy_reached_goal(enemy):
	lives -= 1
	emit_signal("lives_changed", lives)
	enemy.queue_free()
