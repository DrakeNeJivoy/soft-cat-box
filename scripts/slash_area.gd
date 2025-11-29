extends Area2D

@onready var collision: CollisionPolygon2D = get_node_or_null("CollisionShape2D") as CollisionPolygon2D
@onready var sprite: Sprite2D = get_node_or_null("Sprite2D") as Sprite2D
@onready var main_char: CharacterBody2D = $"../.."

var current_elements
var slash_damage = 10
var slash_delay = 1
var slash_scale = 1
var slash_slice = false
var slash_dash = false
var slash_boom = false

var WaveScene := preload("res://objects/damage_wave.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_elements = GameManager.get_elements()
	GameManager.change_element.connect(_change_params)
	params(current_elements)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not visible:
		monitoring = false
	else:
		monitoring = true

func _change_params():
	current_elements = GameManager.get_elements()
	params(current_elements)
	
	
func params(current_elements):
	if "Fire" in current_elements:
		slash_damage = 20
	else: slash_damage = 10
	if "Wind" in current_elements:
		slash_delay = 0.5
	else: slash_delay = 1
	if "Light" in current_elements:
		slash_scale = 2
	else: slash_scale = 1
	if "Fire" in current_elements and "Wind" in current_elements:
		slash_dash = true
	else: slash_dash = false
	if "Fire" in current_elements and "Light" in current_elements:
		slash_boom = true
	else: slash_boom =  false
	if "Wind" in current_elements and "Light" in current_elements:
		slash_slice = true
	else: slash_slice = false
	
	scale = Vector2(slash_scale, slash_scale) 
	if slash_slice:
		GameManager.set_perk_wind_slice(true)
		GameManager.emit_signal("cng_perk")
	else:
		GameManager.set_perk_wind_slice(false)
		GameManager.emit_signal("cng_perk")
	#print("HelloHelloa")
	GameManager.set_attack_speed(slash_delay)
	#print("HelloHelloa")
	GameManager.emit_signal("cng_ats")
	#print("HelloHelloa")
	
func _on_body_entered(body: Node2D) -> void:
	if visible:
		if body.is_in_group("enemy") or body.name == "Enemy":
			GlobalSignal.hit.emit(slash_damage)
			if slash_boom:
				print(slash_boom)
				cast_wave(body)

func cast_wave(body):
	var wave = WaveScene.instantiate()
	wave.global_position = body.global_position
	get_tree().current_scene.add_child(wave)

	
