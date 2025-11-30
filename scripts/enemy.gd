extends CharacterBody2D

# --- ПАРАМЕТРЫ ---
@export var speed := 250.0
@export var attack_distance := 100.0
@export var attack_cooldown := 1.0
@export var damage := 25
@export var hp := 15
var current_hp
var dead = false

# --- СОСТОЯНИЯ ---
var player: Node2D
var is_attacking := false
var can_attack := true
var already_hit := false
var facing := 1   # 1 = right, -1 = left

var timer_to_attack = 0
var activated_hitbox = false

# --- УЗЛЫ ---
@onready var anim_sprite: AnimatedSprite2D = $EnemySprite
@onready var area_attack: AnimatedSprite2D = $AreaAttack/AnimatedSprite2D
#@onready var anim_attacl: AnimationPlayer = $AreaAttack/AnimationPlayer
@onready var area_attack_area: Area2D = $AreaAttack
@onready var hitbox_right: Area2D = $HitBoxRight
@onready var hitbox_left: Area2D = $HitBoxLeft
@onready var hitbox_right_shape: CollisionShape2D = $HitBoxRight/HitBox_RightCollision
@onready var hitbox_left_shape: CollisionShape2D = $HitBoxLeft/HitBox_LeftCollision

@onready var timer: Timer = $Timer


func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	
	timer.one_shot = true
	timer.timeout.connect(_on_attack_cooldown_finished)
	hitbox_right.connect("body_entered", Callable(self, "_on_hitbox_body_entered"))
	hitbox_left.connect("body_entered", Callable(self, "_on_hitbox_body_entered"))
	# Отключаем оба хитбоксаd по умолчанию
	deactivate_hitbox()
	GlobalSignal.hit.connect(_hitted)
	current_hp = hp


func _physics_process(delta):
	if dead:
		return
	
	timer_to_attack += delta
	
	if is_attacking and timer_to_attack >= 1.1 and activated_hitbox:
		activate_hitbox()
		activated_hitbox = false
	
	if not player:
		return

	var dist = position.distance_to(player.position)

	# Если идёт атака — не двигаться
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Если игрок на дистанции атаки — атаковать
	if dist <= attack_distance:
		velocity = Vector2.ZERO
		move_and_slide()

		if can_attack:
			_start_attack()
		return

	# Иначе двигаться к игроку
	_move_to_player(delta)
	_update_attack_direction()


# --- ДВИЖЕНИЕ ---
func _move_to_player(delta):
	if not player:
		return
	
	var dist = position.distance_to(player.position)
	var y_diff = player.position.y - position.y
	if abs(y_diff) > 5:
		velocity = Vector2(0, sign(y_diff) * speed)
		move_and_slide()
		return
	
	var x_diff = player.position.x - position.x
	if abs(x_diff) > attack_distance:
		velocity = Vector2(sign(x_diff) * speed, 0)
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		if can_attack:
			_start_attack()

	# Визуальный поворот спрайта
	if player.global_position.x < global_position.x:
		anim_sprite.flip_h = true
		facing = -1
	else:
		anim_sprite.flip_h = false
		facing = 1

	anim_sprite.play("walk")


# --- АТАКА ---
func _start_attack():
	is_attacking = true
	can_attack = false
	already_hit = false
	timer_to_attack = 0
	activated_hitbox = true
	
	velocity = Vector2.ZERO
	move_and_slide()
	
	_update_attack_direction()
	
	area_attack.play("attack")
	
	await area_attack.animation_finished
	_end_attack()


# --- НОВАЯ ФУНКЦИЯ: зеркалирование и позиционирование области атаки ---
### >>> NEW
func _update_attack_direction():
	if player.global_position.x < global_position.x:
		# Игрок слева
		area_attack.flip_h = false
		area_attack.position.x = 0
		facing = -1
	else:
		# Игрок справа
		area_attack.flip_h = true
		area_attack.position.x = 0
		facing = 1
### <<< NEWa	


# --- ВЫКЛЮЧЕНИЕ АТАКИ ---
func _end_attack():
	is_attacking = false
	deactivate_hitbox()
	timer.start(attack_cooldown)
	area_attack.play("walking")


func _on_attack_cooldown_finished():
	can_attack = true


func _disable_hitboxes():
	hitbox_right_shape.disabled = true
	hitbox_left_shape.disabled = true


func _on_hitbox_body_entered(body):
	print("Hitbox entered by: ", body.name)
	if is_attacking and not already_hit and body.is_in_group("player"):
		already_hit = true
		GlobalSignal.take_dmg.emit(damage)

func activate_hitbox():
	already_hit = false
	hitbox_left.monitoring = true
	hitbox_right.monitoring = true
	#if facing == 1:
		#hitbox_right_shape.disabled = false
		#hitbox_left_shape.disabled = true
	#else:
		#hitbox_right_shape.disabled = true
		#hitbox_left_shape.disabled = false
	
func deactivate_hitbox():
	#hitbox_right_shape.disabled = true
	#hitbox_left_shape.disabled = true
	
	hitbox_left.monitoring = false
	hitbox_right.monitoring = false

func _hitted(dmg, body):
	if self == body and not dead:
		current_hp -= dmg
		print(current_hp)
		
		if current_hp<=0:
			dead = true
			area_attack.play("death")
			ElevatorManager.emit_signal("enemy_die")


func _on_animated_sprite_2d_animation_finished() -> void:
	if dead: 
		anim_sprite.stop()
