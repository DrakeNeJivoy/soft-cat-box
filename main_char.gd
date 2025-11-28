extends CharacterBody2D
@onready var main_char: CharacterBody2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed := 700.0
var dialog_active := false

func _ready() -> void:
	GlobalSignal.dialog_started.connect(_on_dialog_started)
	GlobalSignal.dialog_end.connect(_on_dialog_end)

func _physics_process(delta):
	if dialog_active:
		# Игрок заморожен, выходим из обработки ввода
		velocity = Vector2.ZERO
		return
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()	
	move_and_slide()
		
	if input_vector.x != 0:
		$AnimatedSprite2D.flip_h = input_vector.x < 0

	var accel = 800
	var friction = 600
	if input_vector.length() > 0:
		velocity = velocity.move_toward(input_vector * speed, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
func _on_dialog_started():
	dialog_active = true
	
func _on_dialog_end():
	dialog_active = false
