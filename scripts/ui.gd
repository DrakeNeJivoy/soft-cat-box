extends Control

@onready var inventory_visible: bool = false
@onready var inventory := $Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.visible = false  # Инвентарь скрыт по умолчанию


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_inventory() -> void:
	if inventory_visible: return
	inventory_visible = true
	inventory.visible = true
	get_tree().paused = true  # Пауза всей игры
	# Опционально: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE  // Показать курсор
	
# Функция закрытия (по ESC или кнопке)
func close_inventory() -> void:
	if not inventory_visible: return
	inventory_visible = false
	inventory.visible = false
	get_tree().paused = false  # Снятие паузы
	# Опционально: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED  // Скрыть курсор для FPS/третьего лица
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):  # Настройте в Project Settings > Input Map
		if not inventory_visible:
			open_inventory()
		else:
			close_inventory()
	elif inventory_visible and event.is_action_pressed("ui_cancel"):  # ESC для закрытия
		close_inventory()
		get_viewport().set_input_as_handled()  # Блокируем дальнейшую обработку события
