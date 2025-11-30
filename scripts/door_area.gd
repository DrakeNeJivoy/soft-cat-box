extends Area2D

var player_in_range
#@onready var parent := get_parent()
@onready var dialog_sign: Sprite2D = $"../DialogSign"
@export var path: = ""

#var dialog_text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file(path)


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
	


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
