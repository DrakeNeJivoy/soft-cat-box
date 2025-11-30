extends Node2D

var count_enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count_enemy = 4
	ElevatorManager.enemy_die.connect(_enemy_count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _enemy_count():
	count_enemy -= 1
	if count_enemy <= 0:
		ElevatorManager.set_door_visible(true)
		ElevatorManager.emit_signal("update_door")
