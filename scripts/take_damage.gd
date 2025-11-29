# TakeDamage.gd
extends Area2D

class_name TakeDamage  # ← это даёт имя класса для GDScript

@export var damage: int = 10
var active: bool = true

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if active and body.is_in_group("player"):
		GlobalSignal.take_dmg.emit(damage)
