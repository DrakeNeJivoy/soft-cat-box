extends StaticBody2D

@onready var dialog_sign = $DialogSign

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialog_sign.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
