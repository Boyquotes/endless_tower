extends Control

@onready var player: CharacterBody2D = GameController.player

#HEALTH BAR 
func _ready() -> void:
	$txt_health.text = str("Health: ", GameController.health)
	player.update_health.connect(_on_update_health)
	
	#CURRENT FLOOR 
	$floor/txt_floor.text = str("Floor: ", GameController.level)
	
func _on_update_health(health: int) -> void:
	$txt_health.text = str("Health: ", health)
	
	
func _on_update_floor(level: int) -> void:
	$floor/txt_floor.text = str("Floor ", GameController.level)
	
	
