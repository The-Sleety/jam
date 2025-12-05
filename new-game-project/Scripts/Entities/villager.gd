extends Node2D

@onready var tile_map: TileMap = $"../TileMap"
@onready var player: CharacterBody2D = $"../Player"

var astar_grip: AStarGrid2D
var current_id_path: Array[Vector2i] = []
var Speed = randf_range(2,3)
var canHit = true
var cooldown = 2.4
var maxHealth = randf_range(80,120)
var Health = maxHealth
var canMove = true

func _ready() -> void:
	astar_grip = AStarGrid2D.new()
	astar_grip.region = tile_map.get_used_rect()
	astar_grip.cell_size = Vector2(32, 32)
	astar_grip.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grip.update()

	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x,
				y + tile_map.get_used_rect().position.y
			)

			var tiledata = tile_map.get_cell_tile_data(0, tile_position)

			if tiledata == null or tiledata.get_custom_data("walkable") == false:
				astar_grip.set_point_solid(tile_position)


func _physics_process(_delta: float) -> void:
	get_new_path()
	if current_id_path.is_empty():
		return

	var target_position = tile_map.map_to_local(current_id_path.front())
	global_position = global_position.move_toward(target_position,Speed)
	if global_position == target_position:
		current_id_path.pop_front()
	
	
	var distance_to_player = global_position.distance_to($"../Player".global_position)
	#var direction = current_id_path.front()
	#var velocity = direction * Speed
	if distance_to_player < 16:
		if canHit:
			var damage = randi_range(10,20)
			$"../Player".getHurt(damage)
			canHit = false
			$HitCooldown.start()
			
	#if velocity == Vector2.ZERO:
	#	$AnimatedSprite2D.play("idle")


func get_new_path():
	var start = tile_map.local_to_map(global_position)
	var end = tile_map.local_to_map(player.global_position)
	
	var id_path = astar_grip.get_id_path(start, end)

	if not id_path.is_empty():
		current_id_path = id_path.slice(1)
		
		if current_id_path.size() != 0:
			var last = current_id_path[current_id_path.size() -1].x
			var current = current_id_path.front().x
			if current > last:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("right")
			else:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("right")
			

func getHurt(Damage: int):
	canMove = false
	canHit = false
	$HitResultCooldown.start()

	Health -= Damage
	if Health <= 0:
		queue_free()


func _on_hit_cooldown_timeout() -> void:
	canHit = true

func _on_hit_result_cooldown_timeout() -> void:
	canMove = true
	canHit = true
