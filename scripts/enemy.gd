extends CharacterBody2D

# --- ПАРАМЕТРЫ ---
@export var speed := 200.0
@export var attack_distance := 150.0
@export var attack_cooldown := 1.0
@export var damage := 10

# --- СОСТОЯНИЯ ---
var player: Node2D
var is_attacking := false
var can_attack := true
var already_hit := false
var hitbox_active := false

# --- УЗЛЫ ---
@onready var anim_sprite: AnimatedSprite2D = $EnemySprite
@onready var attack_anim: AnimatedSprite2D = $AttackArea/AnimatedSprite2D
@onready var attack_player: AnimationPlayer = $AttackArea/AnimationPlayer
@onready var hitbox_area: Area2D = $HitBox
@onready var hitbox_shape: CollisionShape2D = $HitBox/CollisionShape2D
@onready var timer: Timer = $Timer

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

	timer.one_shot = true
	if not timer.timeout.is_connected(_on_attack_cooldown_finished):
		timer.timeout.connect(_on_attack_cooldown_finished)

	hitbox_shape.disabled = true
	hitbox_area.monitoring = false

	if not hitbox_area.body_entered.is_connected(_on_hitbox_body_entered):
		hitbox_area.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(delta):
	if not player:
		return
	
	_face_player()  # поворачиваемся к игроку каждый кадрф
	var distance = position.distance_to(player.position)
	
	
	# Когда атакует, враг стоит
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	if distance > attack_distance:
		attack_player.stop()      # Останавливаем AnimationPlayer
		deactivate_hitbox()       # Выключаем хитбокс
		end_attack()              # Завершаем атаку
		return
	
		
	
	# Если игрок в радиусе атаки
	if distance <= attack_distance:
		velocity = Vector2.ZERO
		move_and_slide()
		if can_attack:
			_start_attack()
		return	
	 # Иначе идёт к игроку
	_move_to_player(delta)


func _move_to_player(delta):
	var dir = (player.position - position).normalized()
	velocity = dir * speed
	move_and_slide()
	anim_sprite.play("walk")

func _face_player():
	if not player:
		return
	
	if player.position.x > position.x:
		anim_sprite.flip_h = false    # смотрим вправо
		attack_anim.flip_h = false
		$AttackArea.position.x = abs($AttackArea.position.x)
	else:
		anim_sprite.flip_h = true     # смотрим влево
		attack_anim.flip_h = true
		$AttackArea.position.x = -abs($AttackArea.position.x)

# --- АТАКА ---
func _start_attack():
	if is_attacking:
		return
	is_attacking = true
	can_attack = false
	already_hit = false

	velocity = Vector2.ZERO
	move_and_slide()
	anim_sprite.play("walk")
	attack_anim.play("attack")	
	attack_player.play("attack")
	_face_player()


# --- AnimationPlayer Call Methods ---
func activate_hitbox():
	hitbox_active = true
	hitbox_shape.disabled = false
	hitbox_area.monitoring = true

func deactivate_hitbox():
	hitbox_active = false
	hitbox_shape.disabled = true
	hitbox_area.monitoring = false

func end_attack():
	is_attacking = false
	timer.start(attack_cooldown)


# --- Кулдаун ---
func _on_attack_cooldown_finished():
	can_attack = true


# --- НАНЕСЕНИЕ УРОНА ---
func _on_hitbox_body_entered(body):
	if not hitbox_active:
		return
	if already_hit:
		return

	if body.is_in_group("player"):
		already_hit = true
		GlobalSignal.take_dmg.emit(damage)
