extends Area2D

@export var path: = ""
@onready var dialog_sign: Node = null
var player_in_range
@onready var parent := get_parent()
#@onready var dialog_sign: Sprite2D = $"../DialogSign"

var dialog_text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("Не удалось открыть файл!")
		return
	var text := file.get_as_text()
	var result : Variant = JSON.parse_string(text)
	if result == null:
		print("Ошибка парсинга JSON")
		return
	dialog_text = result
	dialog_sign = get_node_or_null("../DialogSign")
	if dialog_sign:
		dialog_sign.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		#GameManager.add_unlock_element("Fire")
		#GameManager.add_unlock_element("Wind")
		#GameManager.add_unlock_element("Light")
		GlobalSignal.open_dialog.emit(dialog_text, parent)
		SourceManager.set_door_visible(true)
		SourceManager.emit_signal("update_door")


func _on_body_entered(body: Node2D) -> void:
	if dialog_sign and body.name == 'MainChar':
		dialog_sign.visible = true
		player_in_range = true
	else:
		print("Неа")

func _on_body_exited(body: Node2D) -> void:
	if dialog_sign and body.name == 'MainChar':
		dialog_sign.visible = false
		player_in_range = false
	else:
		print("Неа")
	
