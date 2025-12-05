extends CharacterBody2D


var Speed = randf_range(20, 50)


func _physics_process(delta: float) -> void:
	position += (get_tree().get_first_node_in_group("Player").global_position - position) / Speed
	move_and_slide()
