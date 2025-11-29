extends Node

var elements = []
var unlock_elements = ["Fire","Wind","Light"]

signal change_element
signal unlock_new_element
signal cng_ats
signal cng_perk

var battle_area = true

var attack_speed = 1

var perk_wind_wave = false
var perk_fire_dash = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_element(element):
	elements.append(element)
	emit_signal("change_element")
	
func remove_element(element):
	elements.erase(element)
	emit_signal("change_element")
	
func clear_elements():
	elements.clear()
	print(elements)
	
func get_elements():
	return elements
	
func get_unlock_element():
	return unlock_elements
	
func add_unlock_element(elements):
	unlock_elements.append(elements)
	emit_signal("unlock_new_element")
	
func set_attack_speed(ats):
	attack_speed = ats
	
func get_attack_speed():
	return attack_speed
	
func get_perk_wind_slice():
	return perk_wind_wave

func get_perk_fire_dash():
	return perk_fire_dash

func set_perk_wind_slice(perk):
	perk_wind_wave = perk

func set_perk_fire_dash(perk):
	perk_fire_dash = perk
	
func get_butttle_area():
	return battle_area
