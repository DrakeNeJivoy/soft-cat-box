extends Node

var elements = []
var unlock_elements = []

signal change_element
signal unlock_new_element

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_element(element):
	elements.append(element)
	emit_signal("change_element")
	
func remove_element(element):
	elements.erase(element)
	emit_signal("change_element")
	
func get_elements():
	return elements
	
func get_unlock_element():
	return unlock_elements
	
func add_unlock_element(elements):
	unlock_elements.append(elements)
	emit_signal("unlock_new_element")
	
