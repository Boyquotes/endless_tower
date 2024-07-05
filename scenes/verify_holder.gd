extends Control

@export var holder_collection: NFTCollection
@onready var holder_indication: Panel = $verified_ui
#@export var holder_multiplier: GameController.health = 150    #TO ADD A SPECIFC BONUS TO HOLDERS

func _ready():
	holder_indication.visible = false

func _show_holder() -> void:
	#$verified_ui.show()
	var holder_nfts: Array[Nft] = SolanaService.get_nfts_from_collection(holder_collection)
	holder_indication.visible = true
	
	if holder_nfts.size() > 0:
		GameController.health = 150
	
