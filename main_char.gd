extends CharacterBody2D
@onready var main_char: CharacterBody2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var slots = [$HBoxContainer/Fire, $HBoxContainer/Light, $HBoxContainer/Wind]
@onready var slash_nodes = [$Slashes/Slash1, $Slashes/Slash2]

var attack_time := 0.0      # кулдаун между атаками
var attack_lifetime := 0.0  # время жизни слеша
var attack_speed := 0.3     # скорость атаки (секунды)
var is_attacking := false   # флаг атаки
var attack_stage := 0          # 0 = нет атаки, 1 = первая атака, 2 = вторая атака
var queued_attack := false     # игрок нажал кнопку повторно для комбо
var combo_timer := 0.0
var combo_window := 0.1   # 0.1 секунды на нажатие повторно

var postfix = ""

var battle_area = false

var slash_slice = false
var fire_dash = false

@export var speed := 700.0
var dialog_active := false

@export var max_health: int = 100
var current_health: int

var facing_direction := "right"

var SliceScene := preload("res://objects/wind_wave.tscn")

func _ready() -> void:
	GlobalSignal.dialog_started.connect(_on_dialog_started)
	GlobalSignal.dialog_end.connect(_on_dialog_end)
	current_health = max_health
	# Подписка на глобальный сигнал
	GlobalSignal.take_dmg.connect(Callable(self, "_on_take_damage"))
	GameManager.change_element.connect(_change_element)
	attack_speed = GameManager.get_attack_speed()
	GameManager.cng_ats.connect(_change_attack_speed)
	GameManager.cng_perk.connect(_check_perks)
	battle_area = GameManager.get_butttle_area()
	$Slashes.scale.x = -1
	animated_sprite_2d.animation_finished.connect(_on_attack_animation_finished)
	
func _on_take_damage(amount: int) -> void:
	current_health -= amount
	print("MainChar получил ", amount, " урона. Здоровье: ", current_health)

	if current_health <= 0:
		GameManager.clear_elements()
		var scene = get_tree().get_current_scene()
		var panel_path = "MainChar/Camera2D/GameOverPanel"

		if scene.has_node(panel_path):
			var game_over_panel = scene.get_node(panel_path)
			game_over_panel.show_game_over()
		else:
			push_error("GameOverPanel не найден по пути: " + panel_path)

func _process(delta: float) -> void:
	pass

func _physics_process(delta):
		
	if dialog_active:
		# Игрок заморожен, выходим из обработки ввода
		velocity = Vector2.ZERO
		return
	
	if battle_area:
		# Кулдаун между атаками
		attack_time += delta
		
		# Запуск атаки (по кнопке + кулдаун прошёл)
		if Input.is_action_just_pressed("attack") and attack_time >= attack_speed:
			if is_attacking:
				queued_attack =true
			else:
				start_attack()
		
		# Обновляем время жизни слеша
		if is_attacking:
			attack_lifetime += delta
			# Обновляем положение спрайта во время атаки
			animated_sprite_2d.position.y = -39

			# Проверяем окно комбо для первой атаки
			if attack_stage == 1:
				if combo_timer > 0:
					combo_timer -= delta
					if queued_attack:
						attack_stage = 2
						queued_attack = false
						combo_timer = 0.0
						animated_sprite_2d.play("second_attack_" + facing_direction + postfix)
				#elif combo_timer <= 0 and not queued_attack:
					#animated_sprite_2d.play("cancel_animation_" + facing_direction)
			#elif attack_stage == 2:
				#if attack_lifetime >= attack_speed:
					#end_attack()
		else:
			animated_sprite_2d.position.y = -25
				
		
				
		if is_attacking:
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
			
		if input_vector.x != 0:  # только если есть ввод по горизонтали
				$Slashes.scale.x = -1 if facing_direction == "right" else 1
				$Slashes.position.x = 10 if facing_direction == "right" else -10
		if battle_area:
			animated_sprite_2d.play("fight_run_" + facing_direction + postfix)
		else: animated_sprite_2d.play("walk_" + facing_direction)
	else:
		if battle_area:
			animated_sprite_2d.play("fight_idle_" + facing_direction + postfix)
		else: animated_sprite_2d.play("idle_" + facing_direction)

	var accel = 800
	var friction = 1200
	if is_moving:
		velocity = velocity.move_toward(input_vector * speed, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	move_and_slide()
	
func _on_dialog_started():
	dialog_active = true
	
func _on_dialog_end(parent):
	dialog_active = false

func _change_element():
	var elements = GameManager.get_elements()
	postfix = ""
	if "Fire" in elements:
		postfix += "_fire"
	if "Wind" in elements:
		postfix += "_wind"
	if "Light" in elements:
		postfix += "_light"
	for bar in slots:
		if bar.name in elements:
			bar.visible = true
		else:
			bar.visible = false
		
func _change_attack_speed():
	attack_speed = GameManager.get_attack_speed()
	print(attack_speed)

func start_attack() -> void:
	if slash_slice:
		cast_slice()
	# Показываем слеш(и)
	is_attacking = true
	attack_stage = 1
	queued_attack = false
	combo_timer = combo_window
	attack_lifetime = 0.0
	animated_sprite_2d.position.y = -39
	animated_sprite_2d.play("first_attack_" + facing_direction + postfix)

	slash_nodes[0].visible = true
	#for slash in slash_nodes:
		#slash.visible = true
	
	# Здесь наносишь урон врагам!
	#deal_damage_to_enemies()

func end_attack() -> void:
	# Прячем слеш(и)
	for slash in slash_nodes:
		slash.visible = false
	
	is_attacking = false

func _check_perks():
	slash_slice = GameManager.get_perk_wind_slice()
	fire_dash = GameManager.get_perk_fire_dash()
	
func cast_slice():
	var wave = SliceScene.instantiate()
	wave.global_position = global_position
	wave.scale = Vector2(2, 2)
	wave.global_position.y -= 100
	var dir: Vector2
	if facing_direction == "right":
		dir = Vector2.RIGHT  
	else:
		dir = Vector2.LEFT
		#wave.scale.x = -1
		
	wave.set_direction(dir)
	
	get_tree().current_scene.add_child(wave)
	if dir.x < 0:
		wave.wave_sprite.flip_h = true
		
func _on_attack_animation_finished():
	if attack_stage == 1:
		if queued_attack:
			attack_stage = 2
			slash_nodes[0].visible = false
			if "Light" in GameManager.get_elements():
				slash_nodes[1].position.y = 28.0
			else:
				slash_nodes[1].position.y = 0
			slash_nodes[1].visible = true
			if slash_slice:
				cast_slice()
			animated_sprite_2d.play("second_attack_" + facing_direction + postfix)
		else:
			attack_stage = 0
			animated_sprite_2d.play("cancel_animation_" + facing_direction + postfix)
			#end_attack()

	elif attack_stage == 2:
		end_attack()
	elif attack_stage == 0:
		end_attack()
	#else:
		#end_attack()
