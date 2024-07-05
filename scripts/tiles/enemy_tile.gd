extends CharacterBody2D

var direction : Vector2
var grid_size : int = GameController.grid_size
var animator  : AnimatedSprite2D
var strong    : int = 5  #ENEMY POWER
#var is_critical: int = 8 #ENEMY CRIT POWER
var health    : int = 2  #ENEMY HEALTH
var time_effect: float = 0.25

@onready var raycast: RayCast2D = $raycast
@onready var target : CharacterBody2D = GameController.player
@onready var damage_numbers_origin = $damage_numbers_origin #DAMAGE NUMBERS


#RANDOM SPAWN FOR ENEMIES
func _ready() -> void:
	randomize()
	#animator = $enemy_01 if randi_range(0,1) == 0 else $enemy_02
	var random_int = randi() % 4
	if random_int == 0:
		animator = $enemy_01
	elif random_int == 1:
		animator = $enemy_02
	elif random_int == 2:
		animator = $enemy_03
	else:
		animator = $enemy_04
	#animator = $enemy_02 if randi_range(0,1) == 0 else $enemy_03
	#animator = $enemy_03 if randi_range(0,1) == 0 else $enemy_04
	#animator = $enemy_02 if randi_range(0, 1) < 0.5 else $enemy_03
	animator.visible = true #LEMBRAR DE DEIXAR O SPRITE DOS ENEMIES NAO VISIVEIS
	target.movement.connect(_move)
	
#ENEMY MOVE FOLLOWING THE PLAYER
func _move() -> void:
	animator.flip_h = false if target.global_position.x < global_position.x else true
	
	await get_tree().create_timer(0.2).timeout
	var dir: Vector2
	if abs (target.global_position.x - global_position.x) == 0:
		dir = Vector2.DOWN if target.global_position.y > global_position.y else Vector2.UP
	else:
		dir  = Vector2.RIGHT if target.global_position.x > global_position.x else Vector2.LEFT
		
	direction = dir * grid_size
	raycast.target_position = direction
	raycast.force_raycast_update()
	
	#ENEMY COLLIDING, IF NOT COLLIDE, CAN MOVE
	if not raycast.is_colliding():
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", position + direction, 0.2)
	else: #IF FOUND THE PLAYER, ENEMY DO THE ATTACK
		var collision = raycast.get_collider()
		if collision.name == "player":
			_attack()
			
			
#ENEMY ATTACK
func _attack() -> void:
	target.apply_damage(strong, true)
	animator.play("attack")
	await animator.animation_finished
	animator.play ("idle")
	
	#APPLY DAMAGE ON ENEMY
func apply_damage() -> void:
	health -= 1
	#if is_critical:
		#health *= 2
	DamageNumbers.display_number(strong, damage_numbers_origin.global_position)
	
	_create_effect()
	await get_tree().create_timer(time_effect).timeout
	
	if health <= 0:
		animator.play ("die")
		await animator.animation_finished
		queue_free()
			
	
		#EFEITO ENCOLHER/CRESCER
func _create_effect() -> void:
		var effect: Tween = create_tween()
		effect.tween_property(self, "scale", Vector2.ONE / 2, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
		effect.tween_property(self, "scale", Vector2.ONE, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
