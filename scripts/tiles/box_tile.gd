extends StaticBody2D

@onready var damage_numbers_origin = $damage_numbers_origin #DAMAGE NUMBERS

var resistance : int = 1
var index_anim : int
var box       : Array = [ "01", "02" ]
var time_effect: float = 0.25

func _ready() -> void:
	randomize()
	index_anim = randi () % box.size()
	$sprite_idle.play(box[index_anim]) #IDLE BOX SPRITE
	$sprite_damage.play(box[index_anim]) #DAMAGE BOX SPRITE
	
	#FUNC TO DESTROY BOX
func apply_damage() -> void:
	resistance -= 1
	DamageNumbers.display_number(resistance, damage_numbers_origin.global_position)
	
	_create_effect()
	await get_tree().create_timer(time_effect).timeout
	
	
	#SHOW THE SPRITE DAMAGE WHEN HIT THE BOX
	if resistance <= 0:
		queue_free()
	elif resistance <= 2:
		$sprite_idle.hide()
		$sprite_damage.show()
		
		
		#EFEITO ENCOLHER/CRESCER
func _create_effect() -> void:
		var effect: Tween = create_tween()
		effect.tween_property(self, "scale", Vector2.ONE / 2, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
		effect.tween_property(self, "scale", Vector2.ONE, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
