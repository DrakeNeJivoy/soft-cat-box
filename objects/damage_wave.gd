extends Node2D
class_name DamageWave

@export var damage := 50          # урон волны
@export var wave_speed := 500.0   # пикселей/сек (скорость роста)
@export var lifetime := 0.4       # сколько живёт (сек)
@export var knockback := 300.0    # отбрасывание

@onready var wave_sprite: Sprite2D = $WaveSprite
@onready var hit_area: Area2D = $HitArea
@onready var collision_shape: CollisionShape2D = $HitArea/CollisionShape2D
@onready var tween: Tween = create_tween()

var enemies_hit: Array[Node] = []  # чтобы не бить дважды

func _ready():
	# Запускаем анимацию сразу при создании
	animate_wave()
	#hit_area.body_entered.connect(_on_enemy_hit)

func animate_wave():
	var shape: CircleShape2D = collision_shape.shape as CircleShape2D
	var final_radius = wave_speed * lifetime
	
	# Растёт радиус коллизии
	tween.tween_method(
		func(radius): shape.radius = radius,
		0.0, final_radius, lifetime
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	# Масштаб спрайта (синхронно)
	tween.parallel().tween_property(
		wave_sprite, "scale", Vector2.ONE * 3.0, lifetime
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	# Затухание прозрачности
	tween.parallel().tween_property(
		wave_sprite, "modulate:a", 0.0, lifetime
	).set_trans(Tween.TRANS_LINEAR)
	
	# Удаляем себя в конце
	tween.tween_callback(queue_free).set_delay(lifetime)
	


#func _on_enemy_hit(body: Node2D):
	#if body in enemies_hit or not body.has_method("take_damage"):
		#return
	#
	#enemies_hit.append(body)
	
	# Наносим урон и отбрасываем
	#var direction = (body.global_position - global_position).normalized()
	#body.take_damage(damage, direction * knockback)


func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") or body.name == "Enemy":
		print("привет")
		GlobalSignal.hit.emit(10)
