extends Node

var level : int = 1
var health : int = 100  #SET THE PLAYER HP
var grid_size: int = 32
var player : CharacterBody2D

#RESET LEVEL AND HEALTH, AFTER RESTART THE GAME
func restart_game() -> void:
	level = 1
	health = 100
	


