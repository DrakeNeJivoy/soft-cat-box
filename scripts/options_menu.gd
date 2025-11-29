extends Control

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var volume_slider: HSlider = $VBoxContainer/VolumeSlider
@onready var volume_label: Label = $VBoxContainer/VolumeLabel
@onready var resolution_option: OptionButton = $VBoxContainer/ResolutionOption
@onready var fullscreen_checkbox: CheckBox = $VBoxContainer/FullscreenCheckbox
@onready var back_button: Button = $VBoxContainer/BackButton

func _ready():
	volume_slider.value = AudioServer.get_bus_volume_db(0)
	volume_label.text ="Game Volume " + " %0.1f dB" % volume_slider.value
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	resolution_option.clear()
	resolution_option.add_item("1920x1080")
	resolution_option.add_item("1280x720")
	resolution_option.add_item("800x600")

	volume_slider.value_changed.connect(Callable(self, "_on_volume_changed"))
	resolution_option.item_selected.connect(Callable(self, "_on_resolution_changed"))
	fullscreen_checkbox.toggled.connect(Callable(self, "_on_fullscreen_toggled"))
	back_button.pressed.connect(Callable(self, "_on_back_pressed"))

func _on_volume_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	volume_label.text = "Game Volume " + " %0.1f dB" % value
	
func _on_resolution_changed(index):
	var res = resolution_option.get_item_text(index).split("x")
	var new_size = Vector2(int(res[0]), int(res[1]))
	DisplayServer.window_set_size(new_size)

func _on_fullscreen_toggled(pressed: bool) -> void:
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://entitys/main_menu.tscn")
