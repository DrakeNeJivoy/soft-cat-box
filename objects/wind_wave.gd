extends Node2D
class_name WindWave

@export var damage := 50
@export var travel_speed := 700.0
@export var max_distance := 300.0

@onready var wave_sprite: Sprite2D = $WaveSprite
@onready var hit_area: Area2D = $HitArea
@onready var collision_shape: CollisionShape2D = $HitArea/CollisionShape2D

var enemies_hit: Array[Node] = []
var direction: Vector2 = Vector2.RIGHT
var traveled := 0.0


func _ready():
	hit_area.body_entered.connect(_on_enemy_hit)


func _physics_process(delta):
	var movement: Vector2 = direction * travel_speed * delta
	global_position += movement
	traveled += movement.length()

	if traveled >= max_distance:
		queue_free()

	# визуальный эффект (можно убрать)
	wave_sprite.scale = wave_sprite.scale.lerp(Vector2.ONE * 1.3, delta * 5)


func set_direction(dir: Vector2):
	direction = dir.normalized()


func _on_enemy_hit(body: Node2D):
	if body in enemies_hit:
		return

	# запоминаем чтобы не ударять дважды
	enemies_hit.append(body)

	# распространяем на внешний мир
	emit_signal("hit", damage, body)
