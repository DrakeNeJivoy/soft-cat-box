extends Node2D

var count_enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.set_buttle_area(true)
	print(GameManager.get_butttle_area())
	count_enemy = 4
	ElevatorManager.enemy_die.connect(_enemy_count)

# Called every frame. 'delta' is the elapsed time since the parevious frame.
func _process(delta: float) -> void:
	pass

func _enemy_count():
	count_enemy -= 1
	if count_enemy <= 0:
		get_tree().change_scene_to_file("res://entitys/hub_location.tscn")
