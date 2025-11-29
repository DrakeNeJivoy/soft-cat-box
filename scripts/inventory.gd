extends Control

@onready var right_slots = [$RightSide/Fire, $RightSide/Light, $RightSide/Wind]
@onready var left_slots  = [$LeftSide/ActiveSlot1, $LeftSide/ActiveSlot2]

# Откуда пришёл предмет в активный слот
var left_slot_source := {}  # ActiveSlot → правый слот (родитель)

var dragging_slot: TextureRect = null
var drag_preview: TextureRect = null

func _ready() -> void:
	for slot in right_slots + left_slots:
		slot.mouse_filter = Control.MOUSE_FILTER_STOP

	for slot in right_slots:
		slot.gui_input.connect(_on_right_slot_input.bind(slot))
	for slot in left_slots:
		slot.gui_input.connect(_on_left_slot_input.bind(slot))


func _on_right_slot_input(event: InputEvent, slot: TextureRect):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var icon = slot.get_node("ItemIcon")
		var name = slot.name
		#_change_element(name, "add")
		if event.pressed and icon.texture:
			_start_drag(slot, icon)
		elif !event.pressed and dragging_slot:
			_try_drop(name)


func _on_left_slot_input(event: InputEvent, slot: TextureRect):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var icon = slot.get_node("ItemIcon")
		if icon.texture:
			var home_slot_parent = left_slot_source[slot]
			var name = left_slot_source[slot].name
			_change_element(name, "remove")
			var home_icon = home_slot_parent.get_node("ItemIcon")
			home_icon.texture = icon.texture
			icon.texture = null
			left_slot_source.erase(slot)


func _start_drag(parent_slot: TextureRect, item_icon: TextureRect):
	dragging_slot = parent_slot
	var icon = item_icon
	drag_preview = parent_slot.get_node("DragPreview")
	drag_preview.texture = icon.texture
	drag_preview.visible = true
	parent_slot.modulate = Color(1, 1, 1, 0.4)


func _process(_delta):
	if drag_preview and drag_preview.visible:
		drag_preview.global_position = get_global_mouse_position() - drag_preview.size * 0.5


func _input(event: InputEvent):
	if dragging_slot and (
		event.is_action_pressed("ui_cancel") or
		(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed)
	):
		_cancel_drag()
		get_viewport().set_input_as_handled()


func _try_drop(name):
	for left_slot in left_slots:
		if left_slot.get_global_rect().has_point(get_global_mouse_position()):
			var target_icon = left_slot.get_node("ItemIcon")
			if target_icon.texture == null:
				var source_icon = dragging_slot.get_node("ItemIcon")
				target_icon.texture = source_icon.texture
				target_icon.size = source_icon.size
				source_icon.texture = null
				left_slot_source[left_slot] = dragging_slot
				_change_element(name, "add")
				_finish_drag()
				return
	_cancel_drag()


func _cancel_drag():
	_finish_drag()


func _finish_drag():
	if drag_preview:
		drag_preview.visible = false
	if dragging_slot:
		dragging_slot.modulate = Color(1, 1, 1, 1)
	dragging_slot = null
	drag_preview = null
	
func _change_element(name, actions):
	if actions == "add":
		GameManager.add_element(name)
		var elements = GameManager.get_elements()
		print(elements)
	if actions == "remove":
		GameManager.remove_element(name)
		var elements = GameManager.get_elements()
		print(elements)
