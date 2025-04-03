extends Control

@onready var player: CharacterBody3D = $"../../.."
@onready var trendy_game: Node3D = $"../../../.."


func _on_play_pressed() -> void:
	hide()
	player.game_paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	trendy_game.start()

func _on_pass_pressed() -> void:
	hide()
	player.game_paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_pass_mouse_entered() -> void:
	$Body/Pass/TextureRect.texture = load("res://assets/images/deco-leaves-white.png")
	$Body/Pass/TextureRect2.texture = load("res://assets/images/deco-leaves-white.png")


func _on_pass_mouse_exited() -> void:
	$Body/Pass/TextureRect.texture = load("res://assets/images/deco-leaves-gold.png")
	$Body/Pass/TextureRect2.texture = load("res://assets/images/deco-leaves-gold.png")


func _on_play_mouse_entered() -> void:
	$Body/Play/TextureRect.texture = load("res://assets/images/deco-leaves-white.png")
	$Body/Play/TextureRect2.texture = load("res://assets/images/deco-leaves-white.png")



func _on_play_mouse_exited() -> void:
	$Body/Play/TextureRect.texture = load("res://assets/images/deco-leaves-gold.png")
	$Body/Play/TextureRect2.texture = load("res://assets/images/deco-leaves-gold.png")
