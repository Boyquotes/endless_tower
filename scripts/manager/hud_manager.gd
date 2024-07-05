extends Control

@onready var player: CharacterBody2D = GameController.player

#NFT HOLDER
#@export var holder_collection: NFTCollection
#@onready var verified_ui = $verified_ui


#HEALTH BAR 
func _ready() -> void:
	$txt_health.text = str("Health: ", GameController.health)
	player.update_health.connect(_on_update_health)
	
	#CURRENT FLOOR 
	$floor/txt_floor.text = str("Floor: ", GameController.level)
	
	#NFT HOLDER
	#verified_ui.visible = false
	
	#NFT HOLDER
	#var holder_nfts: Array[Nft] = SolanaService.get_nfts_from_collection(holder_collection)
	
	#NFT HOLDER
	#if holder_nfts.size() > 0:
		#verified_ui.visible = true
	
	
func _on_update_health(health: int) -> void:
	$txt_health.text = str("Health: ", health)
	
	
	
func _on_update_floor(level: int) -> void:
	$floor/txt_floor.text = str("Floor ", GameController.level)
	


