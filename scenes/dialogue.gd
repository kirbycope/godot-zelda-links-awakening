extends Control

@onready var player: CharacterBody3D = $"../../.."
@onready var trendy_game: Node3D = $"../../../.."


func _on_play_pressed() -> void:
	hide()
	trendy_game.get_node("Effects").stream = load("res://assets/sounds/00001 - WAV_1_GUESS_BANK_SE_SYSTEM.wav")
	trendy_game.get_node("Effects").play()
	player.game_paused = false
	player.velocity = Vector3.ZERO
	player.animation_player.stop()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	trendy_game.start()

func _on_pass_pressed() -> void:
	hide()
	trendy_game.get_node("Effects").stream = load("res://assets/sounds/00002 - WAV_2_GUESS_BANK_SE_SYSTEM.wav")
	trendy_game.get_node("Effects").play()
	player.game_paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if trendy_game.is_playing:
		trendy_game.stop()
		trendy_game.is_playing = false


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
