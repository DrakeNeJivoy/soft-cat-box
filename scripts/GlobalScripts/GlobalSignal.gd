extends Node

signal open_dialog(text, parent)
signal dialog_started
signal dialog_end(parent)
signal take_dmg(amount: int)
signal open_inventory
signal hit(amount:int, body)
signal tab_guide_open
signal boss_defeat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace w	ith function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
