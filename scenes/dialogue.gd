extends Control

const DECO_LEAVES_GOLD = preload("res://assets/images/deco-leaves-gold.png")
const DECO_LEAVES_WHITE = preload("res://assets/images/deco-leaves-white.png")
const _00001___WAV_1_GUESS_BANK_SE_SYSTEM = preload("res://assets/sounds/00001 - WAV_1_GUESS_BANK_SE_SYSTEM.wav")
const _00002___WAV_2_GUESS_BANK_SE_SYSTEM = preload("res://assets/sounds/00002 - WAV_2_GUESS_BANK_SE_SYSTEM.wav")
@onready var player: CharacterBody3D = $"../../.."
@onready var trendy_game: Node3D = $"../../../.."


func _on_play_pressed() -> void:
	hide()
	trendy_game.get_node("Effects").stream = _00001___WAV_1_GUESS_BANK_SE_SYSTEM
	trendy_game.get_node("Effects").play()
	player.game_paused = false
	player.velocity = Vector3.ZERO
	player.animation_player.stop()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	trendy_game.start()


func _on_pass_pressed() -> void:
	hide()
	trendy_game.get_node("Effects").stream = _00002___WAV_2_GUESS_BANK_SE_SYSTEM
	trendy_game.get_node("Effects").play()
	player.game_paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if trendy_game.is_playing:
		trendy_game.stop()
		trendy_game.is_playing = false


func _on_pass_mouse_entered() -> void:
	$Body/Pass/TextureRect.texture = DECO_LEAVES_WHITE
	$Body/Pass/TextureRect2.texture = DECO_LEAVES_WHITE


func _on_pass_mouse_exited() -> void:
	$Body/Pass/TextureRect.texture = DECO_LEAVES_GOLD
	$Body/Pass/TextureRect2.texture = DECO_LEAVES_GOLD


func _on_play_mouse_entered() -> void:
	$Body/Play/TextureRect.texture = DECO_LEAVES_WHITE
	$Body/Play/TextureRect2.texture = DECO_LEAVES_WHITE


func _on_play_mouse_exited() -> void:
	$Body/Play/TextureRect.texture = DECO_LEAVES_GOLD
	$Body/Play/TextureRect2.texture = DECO_LEAVES_GOLD
