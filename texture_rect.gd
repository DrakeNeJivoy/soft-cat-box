extends Control

@onready var text_field = $Text
@onready var name_field = $Name
var player

var text_array
var text_lenght
var current = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.open_dialog.connect(_on_open_dialog)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_open_dialog(text):
	text_array = text
	text_lenght = len(text)
	text_field.text = text_array[0].get("text")
	name_field.text = text_array[0].get("name")
	visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	GlobalSignal.emit_signal("dialog_started")


func _on_gui_input(event: InputEvent) -> void:	
	if not visible:
		return
	
	get_viewport().set_input_as_handled()
	
	if visible:	
		if event is InputEventMouseButton and event.pressed:
			if current >= text_lenght:
				visible = false
				text_array = []
				text_lenght = []
				current = 1
				GlobalSignal.emit_signal("dialog_end")
				return
			text_field.text = text_array[current].get("text")
			name_field.text = text_array[current].get("name")
			current += 1
