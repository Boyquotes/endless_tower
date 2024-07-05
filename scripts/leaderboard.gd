extends CanvasLayer
class_name Leaderboard

@export_category("Objects")
@export var _ranking_container: VBoxContainer = null


#MENU BUTTON
func _on_button_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
	
func _show_leaderboad() -> void:
	_ranking_container.show()
	var _sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	
	var _index: int = 0
	for _slot in _ranking_container.get_children():
		if _slot is Label:
			continue
			
		if _sw_result.scores.size() > _index:
			_slot.get_node("position").text = str(_index +1) + ". "
			_slot.get_node("floor").text = " - " + str(_sw_result.scores[_index]["score"])
			_slot.get_node("name").text = _sw_result.scores[_index]["player_name"]
			print()
			
		_index += 1
