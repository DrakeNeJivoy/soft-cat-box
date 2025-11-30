extends Node

var door_visible

signal update_door
signal enemy_die

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_door_visible():
	return door_visible

func set_door_visible(chng):
	door_visible = chng
