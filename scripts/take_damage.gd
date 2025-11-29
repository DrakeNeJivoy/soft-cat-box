extends Area2D

@export var damage: int = 10  # сколько урона наносит зона
@export var active: bool = true  # активна ли зона

func _ready() -> void:
	# Подписываемся на сигнал (если нужно, чтобы зона реагировала на глобальные события)
	# GlobalSignal.take_dmg.connect(_on_take_damage)  # не обязательно для зоны
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if active and body.is_in_group("player"):
		# Отсылаем сигнал глобально, чтобы любой слушатель (например, персонаж) получил урон
			GlobalSignal.take_dmg.emit(damage)
