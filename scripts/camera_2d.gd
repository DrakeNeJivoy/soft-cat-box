extends Camera2D

@export var shake_amount := 1.5      # сила тряски
@export var shake_speed := 20.0      # скорость колебаний
var time := 0.0

func _process(delta):
	time += delta * shake_speed
	offset = Vector2(
		sin(time * 1.3) * shake_amount,
		cos(time * 1.7) * shake_amount
	)
