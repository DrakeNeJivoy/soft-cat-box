extends CharacterBody2D
@onready var main_char: CharacterBody2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var slots = [$HBoxContainer/Fire, $HBoxContainer/Light, $HBoxContainer/Wind]

@export var speed := 700.0
var dialog_active := false

@export var max_health: int = 100
var current_health: int

var facing_direction := "right"

func _ready() -> void:
	GlobalSignal.dialog_started.connect(_on_dialog_started)
	GlobalSignal.dialog_end.connect(_on_dialog_end)
	current_health = max_health
	# Подписка на глобальный сигнал
	GlobalSignal.take_dmg.connect(Callable(self, "_on_take_damage"))
	GameManager.change_element.connect(_change_element)
	
func _on_take_damage(amount: int) -> void:
	current_health -= amount
	print("MainChar получил ", amount, " урона. Здоровье: ", current_health)

	if current_health <= 0:
		var scene = get_tree().get_current_scene()
		var panel_path = "MainChar/Camera2D/GameOverPanel"

		if scene.has_node(panel_path):
			var game_over_panel = scene.get_node(panel_path)
			game_over_panel.show_game_over()
		else:
			push_error("GameOverPanel не найден по пути: " + panel_path)

func die() -> void:
	print("MainChar погиб!")
	queue_free()

func _physics_process(delta):
	if dialog_active:
		# Игрок заморожен, выходим из обработки ввода
		velocity = Vector2.ZERO
		return

	var input_vector := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	
	var is_moving =  input_vector.length() > 0

	if is_moving:
		input_vector = input_vector.normalized()
	
		if input_vector.x > 0:
			facing_direction = "right"
		elif input_vector.x < 0:
			facing_direction = "left"
		
		animated_sprite_2d.play("walk_" + facing_direction)
	else:
		animated_sprite_2d.play("idle_" + facing_direction)

	var accel = 800
	var friction = 1200
	if is_moving:
		velocity = velocity.move_toward(input_vector * speed, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	move_and_slide()
	
func _on_dialog_started():
	dialog_active = true
	
func _on_dialog_end():
	dialog_active = false

func _change_element():
	var elements = GameManager.get_elements()
	for bar in slots:
		if bar.name in elements:
			bar.visible = true
		else:
			bar.visible = false
		
