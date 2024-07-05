extends Control
@onready var pause_menu = preload("res://scenes/pause_menu.tscn")

func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur_menu")

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur_menu")
	
func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()


func _on_resume_pressed():
	resume()


func _on_restart_pressed():
	GameController.restart_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_quit_pressed():
	GameController.restart_game()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _process(delta):
	testEsc()
	
func _pause_menu():
	resume()
	get_tree().change_scene_to_file("res://scenes/pause_menu.tscn")
