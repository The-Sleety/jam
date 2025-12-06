extends Node2D

@export var villager : PackedScene

var spawnCount = 0
var maxSpawn = 7

func spawn():
	if spawnCount <= maxSpawn:
		var v = villager.instantiate()
		$"../..".add_child(v)
		v.global_position = global_position
		spawnCount += 1
		$Timer.start()
		print("spawn")

func _on_timer_timeout() -> void:
	spawn()
