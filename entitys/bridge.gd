extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.clear_elements()
	GameManager.set_buttle_area(true)
	print(GameManager.get_butttle_area())
	GlobalSignal.boss_defeat.connect(_defeat_boss)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _defeat_boss():
	get_tree().change_scene_to_file("res://entitys/main_menu.tscn")
	#var scene = get_tree().get_current_scene()
	#var panel_path = "res://entitys/game_winner_panel.tscn"
#
	#if scene.has_node(panel_path):
		#var game_winner_panel = scene.get_node(panel_path)
		#game_winner_panel.show_game_over()
	#else:
		#push_error("GameOverPanel не найден по пути: " + panel_path)
	
