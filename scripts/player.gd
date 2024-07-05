extends CharacterBody2D

#CUSTOMIZABLE SIGNAL
signal movement 

#HEALTH
signal update_health(health)

@export var sfx_footstep : Array #FOOTSTEP SFX
@export var sfx_attack   : Array #ATTACK SFX
@export var sfx_damage   : Array #PLAYER DAMAGE
@export var sfx_die      : Array

@onready var raycast: RayCast2D = $raycast
@onready var animated_sprite: AnimatedSprite2D = $animated_sprite
@onready var audio_stream_sfx = $audio_stream_sfx #FOOTSTEP SFX


#PLAYER MOVE
var input := { "ui_up": Vector2.UP, "ui_down": Vector2.DOWN, "ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT }
var grid_size := 32
var direction := Vector2.RIGHT * grid_size
var in_move := false
var death := false
var enemy_movement : int = 0


func _ready() -> void:
	randomize() #RANDOMIZE SOUNDS
	GameController.player = self

 
func _input(event: InputEvent) -> void:
	for dir in input.keys():
		if event.is_action_pressed(dir):
			animated_sprite.play("walk") #WALK ANIMATION
			await animated_sprite.animation_finished
			animated_sprite.play("idle")
			_move(dir)
	
	#FUNC TO ACTIVATE THE ATTACK - KEYBOARD: SPACE OR ENTER
	if event.is_action_pressed("ui_accept"):
		_sword()
	
	
func _move(dir: String) -> void:
	if death or in_move: return
	
	in_move= true
	$timer.start()
	
	#CALCULATE DIRECTION
	direction = input[dir] * grid_size
	raycast.target_position = direction
	raycast.force_raycast_update()
	
	if !raycast.is_colliding():
		apply_damage(1) #IF THE PLAYER REALLY MOVES, WILL LOSE 1 HEALTH
		
		#PULL PLAYERS SOUND 
		_play_sound(sfx_footstep)
		
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", position + direction, 0.2)

		
	match dir:
		"ui_right": animated_sprite.flip_h = false
		"ui_left": animated_sprite.flip_h = true
		
		#Regardless of whether the player moves or not, the enemy will move every two actions.
	_move_enemy()  

#RESTORE HP PLAYER
func restore_hp(hp: int) -> void:
	GameController.health += hp
	update_health.emit(GameController.health)
	
	#PLAYER DAMAGE FUNCTION
func apply_damage(strong: int, enemy_hit: bool = false) -> void:
	GameController.health -= strong
	update_health.emit(GameController.health)
	
	#ANIMATION WHEN PLAYER GET HIT BY AN ENEMY
	if enemy_hit:
		_play_sound(sfx_damage) #HURT PLAYER SOUND
		animated_sprite.play("damage")
		await animated_sprite.animation_finished
		animated_sprite.play("idle")
	
	if GameController.health <= 0:
		_play_sound(sfx_die) #DIE PLAYER SOUND
		death = true
		GameController.health = 0
		update_health.emit(GameController.health)
		#$audio_stream_die.play()
		#await $audio_stream_die.finished
		await $audio_stream_sfx.finished  #WAIT THE DIE SOUND, TO END
		get_tree().change_scene_to_file("res://scenes/end.tscn")  #PULL END SCENE

#FUNC TO ACTIVATE THE ATTACK
func _sword() -> void:
	if death or in_move: return
	$sword.global_position = global_position + direction
	$sword/collision.disabled = false
	animated_sprite.play("attack")
	_play_sound(sfx_attack) #ATTACK SOUND
	
	#STOP THE ATTACK ANIMATION
	await animated_sprite.animation_finished
	$sword/collision.disabled = true
	animated_sprite.play("idle")
	
	#IF THE PLAYER PERFORMS AN ATTACK, ENEMIES WILL MOVE
	_move_enemy()
	#IF THE PLAYER DO AN ATTACK, HE WILL LOSE HEALTH
	apply_damage(1)

#MOVE ENEMY - Every two movements of the player, the enemy moves
func _move_enemy() -> void:
	enemy_movement += 1
	if enemy_movement % 2 == 0:
		movement.emit()

#PLAYERS SOUNDS
func _play_sound(sfx: Array) -> void:
	audio_stream_sfx.stream = sfx[randi() % sfx.size()]
	audio_stream_sfx.play()

func _on_timer_timeout():
	in_move = false
	

#Identify breakable boxes #Anything that is breakable, apply this method
func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("apply_damage"):
		body.apply_damage()
