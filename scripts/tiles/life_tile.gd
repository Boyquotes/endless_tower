extends Area2D

@export var sfx_hp_pot : Array
@export var sfx_meat : Array

var hp        : int = 4
var life_temp : int
var life      : Array = ["lifepot", "meat"]

@onready var audio_stream_player = $audio_stream_player


func _ready() -> void:
	randomize()
	life_temp = randi() % life.size()
	$animated_sprite.play(life[life_temp])


func _on_body_entered(body: Node2D) -> void:
	if body.name.match("player"):
		body.restore_hp(hp)
		$collision.queue_free()
		_play_sound() #PULL THE LIFE AND MEAT SOUND
		
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ONE * 1.2, .5)
		tween.tween_property($animated_sprite, "modulate:a", 0, .5).set_delay(.2)
		
		await tween.finished
		queue_free()
		
	
	#LIFE AND MEAT SOUND
func _play_sound(volume = -15) -> void:
	match life_temp: 
		0: audio_stream_player.stream = sfx_hp_pot[randi() % sfx_hp_pot.size()]
		1: audio_stream_player.stream = sfx_meat[randi() % sfx_meat.size()]
	
	audio_stream_player.play()

