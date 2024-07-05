extends Node



func _on_button_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_button_quit_pressed():
	get_tree().quit()

	
#func _on_button_leaderboard_pressed():
	#get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")


func _on_button_tutorial_pressed():
		get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
