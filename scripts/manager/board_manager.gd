extends Node2D

@export var floor_tile : PackedScene
@export var wall_tile: PackedScene
@export var outer_wall_tile : PackedScene
@export var box_tile: PackedScene
@export var spike_tile: PackedScene
@export var life_tile: PackedScene
@export var exit_tile: PackedScene
@export var enemy_tile: PackedScene
@export var audio_background: PackedScene


var column := 8
var rows := 8
var space := 32
var grid_position := []
var box_count = Count.new(5, 9) #HOW MUCH BOX TILES per floor
var spike_count = Count.new(1, 3) #HOW MUCH SPIKE TILES per floor
var life_count = Count.new (2, 6) #HOW MUCH LIFE AND FOOD TILES per floor


func _ready() -> void:
	AudioBackground.play_music_level() #DUNGEON BACKGROUND MUSIC
	print(SolanaService.wallet.get_pubkey().to_string())
	randomize()
	

func _initialize_list() -> void:
	grid_position.clear()
	for x in column - 1:
		for y in rows - 1:
			grid_position.append(Vector2(x * space, y *space))

func _board_setup() -> void:
			for x in range(-1, column +1):
				for y in range(-1, rows +1):
					var temp
					if x == -1 || x == column || y == -1 || y == column:
						temp = outer_wall_tile.instantiate()
					else:
						temp = floor_tile.instantiate()
							
					temp.global_position = Vector2(x * space, y * space)
					add_child(temp)

#RANDOM POSITION FOR BOXES
func _random_position() -> Vector2:
	var random = randi_range(0, grid_position.size() -1)
	var random_pos = grid_position[random]
	grid_position.pop_at(random)
	return random_pos

#FUNC TO SPAWN BOX TILES
#func _spawn_tile() -> void:
	#var tile_count = randi_range(box_count.minimum, box_count.maximum)
	#for i in tile_count:
		#var tile = box_tile.instantiate() as Node2D
		#tile.global_position = _random_position()
		#add_child(tile)

#FUNC TO SPAWN LIFE AND FOOD TILES
#func _spawn_life() -> void:
	#var tile_count = randi_range(life_count.minimum, life_count.maximum)
	#for i in tile_count:
		#var tile = life_tile.instantiate() as Node2D
		#tile.global_position = _random_position()
		#add_child(tile)

#FUNC TO SPAWN RANDOM TILES
func _spawn_object_random(tile: PackedScene, minimum: int, maximum: int) -> void:
	var object_count = randi_range(minimum, maximum)
	for i in object_count:
		var tile_choice = tile.instantiate() as Node2D
		tile_choice.global_position = _random_position()
		add_child(tile_choice)


#FUNC TO SPAWN THE EXIT TILE
func _spawn_exit() -> void:
	var temp_exit = exit_tile.instantiate() as Node2D
	@warning_ignore("integer_division")
	temp_exit.global_position = Vector2(column * space - space, rows - space / 4)
	add_child(temp_exit)


#SETUP SCENE - BY GAME MANAGER SCRIPT
func setup_scene(level: int) -> void:
	_initialize_list()
	_board_setup()
	
	#CHOOSE TILES TO SPAWN
	#HOW MUCH ENEMIES DO YOU WANT TO SPAWN PER FLOOR
	var enemy_count = log(GameController.level) 
	_spawn_object_random(enemy_tile, enemy_count, enemy_count)
	_spawn_object_random(box_tile, box_count.minimum, box_count.maximum)
	_spawn_object_random(spike_tile, spike_count.minimum, spike_count.maximum)
	_spawn_object_random(life_tile, life_count.minimum, life_count.maximum)
	_spawn_exit()


class Count:
	var minimum : int
	var maximum : int
	
	func _init(_minimum: int, _maximum: int) -> void:
		minimum = _minimum
		maximum = _maximum
		
		
