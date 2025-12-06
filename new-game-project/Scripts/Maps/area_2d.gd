extends Area2D
var playerInside = true
var canDamage = true

func _process(_delta: 	float) -> void:
	if !playerInside:
		if canDamage:
			if get_tree().get_first_node_in_group("Player").isVampire:
				get_tree().get_first_node_in_group("Player").getHurt(12)
			else:
				get_tree().get_first_node_in_group("Player").getHurt(6)
			canDamage = false
			$Timer.start
	else:
		if get_tree().get_first_node_in_group("Player").Health <= 100:
			get_tree().get_first_node_in_group("Player").Health += 0.1


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInside = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInside = false	


func _on_timer_timeout() -> void:
	canDamage = true
