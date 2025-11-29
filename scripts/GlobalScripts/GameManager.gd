extends Node

var elements = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_element(element):
	elements.append(element)
	
func remove_element(element):
	elements.erase(element)
	
func get_elements():
	return elements
