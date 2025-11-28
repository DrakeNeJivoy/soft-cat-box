extends Control
@onready var button: Button = $Button

func _ready():
	# Вариант A - явный Callable
	button.connect("pressed", Callable(self, "_on_StartButton_pressed"))
	
	# Вариант B (альтернатива): через свойство сигнала
	# button.pressed.connect(Callable(self, "_on_StartButton_pressed"))

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://levels/mainscene.tscn")
