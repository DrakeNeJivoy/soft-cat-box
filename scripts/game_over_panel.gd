extends CanvasLayer
@onready var restart_button: Button = $Panel/RestartButton
@onready var color_rect: ColorRect = $ColorRect
@onready var panel: Panel = $Panel
	
func _ready():
	visible = false

func show_game_over():
	visible = true
	get_tree().paused = true
	panel.modulate.a = 0
	color_rect.modulate.a = 0

	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.7, 0.5)
	tween.tween_property(panel, "modulate:a", 1.0, 0.5).set_delay(0.2)
	
func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
