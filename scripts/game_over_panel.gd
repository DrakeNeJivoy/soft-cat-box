extends CanvasLayer
@onready var restart_button: Button = $Panel/RestartButton

func _ready():
	$Panel/RestartButton.pressed.connect(Callable(self, "_on_restart_button_pressed"))
	visible = false

func show_game_over():
	visible = true
	get_tree().paused = true
	
func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
