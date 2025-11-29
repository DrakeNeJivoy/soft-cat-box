extends CharacterBody2D

@export var speed := 250.0
@export var target_distance := 150.0
@export var vertical_tolerance := 10.0

var player: Node2D = null

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_warning("Игрок в группе 'player' не найден!")

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var v := Vector2.ZERO
	var dy := player.position.y - position.y
	var dx := player.position.x - position.x

	# выравнивание по высоте
	if abs(dy) > vertical_tolerance:
		v.y = sign(dy) * speed

	# держим дистанцию слева/справа
	if abs(dx) > target_distance:
		v.x = sign(dx) * speed

	velocity = v
	move_and_slide()
