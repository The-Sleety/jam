extends Node2D

@export var villager : PackedScene


func spawn():
	var v = villager.instantiate()
	$"../..".add_child(v)
	v.global_position = global_position
	$Timer.start()
	print("spawn")

func _on_timer_timeout() -> void:
	spawn()
