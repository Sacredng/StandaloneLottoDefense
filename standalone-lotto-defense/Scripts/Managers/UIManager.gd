extends Node

@onready var money_label: Label = $CanvasLayer/MoneyLabel
@onready var lives_label: Label = $CanvasLayer/LivesLabel
@onready var wave_label: Label = $CanvasLayer/WaveLabel

func update_money(value: int) -> void:
	money_label.text = str(value)

func update_lives(value: int) -> void:
	lives_label.text = str(value)

func update_wave(value: int) -> void:
	wave_label.text = "Wave " + str(value)
