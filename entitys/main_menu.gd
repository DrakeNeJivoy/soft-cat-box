extends Control
@onready var starter_button: Button = $StarterButton
@onready var option_button: Button = $OptionButton
@onready var exit_button: Button = $ExitButton

func _ready():
	# Вариант A - явный Callable
	starter_button.connect("pressed", Callable(self, "_on_StartButton_pressed"))
	option_button.connect("pressed", Callable(self, "_on_OptionsButton_pressed"))
	exit_button.connect("pressed", Callable(self, "_on_ExitButton_pressed"))

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://levels/mainscene.tscn")

func _on_OptionsButton_pressed():
	get_tree().change_scene_to_file("res://entitys/options_menu.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()
	
