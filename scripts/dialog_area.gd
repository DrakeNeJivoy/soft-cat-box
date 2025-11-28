extends Area2D

@onready var dialog_sign: Node = null
var player_in_range
#@onready var dialog_sign: Sprite2D = $"../DialogSign"

var dialog_text = [
	{
		"name": "Drake",
		"text": "Привет!"
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialog_sign = get_node_or_null("../DialogSign")
	if dialog_sign:
		dialog_sign.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		GlobalSignal.emit_signal("open_dialog", dialog_text)


func _on_body_entered(body: Node2D) -> void:
	if dialog_sign and body.name == 'MainChar':
		dialog_sign.visible = true
	else:
		print("Неа")
	player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if dialog_sign and body.name == 'MainChar':
		dialog_sign.visible = false
	else:
		print("Неа")
	player_in_range = false
