extends Area2D

var playerInside = true
var canDamage = true


func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")

	if !playerInside:
		if canDamage:
			if player.isVampire:
				player.getHurt(12)
			else:
				player.getHurt(6)

			canDamage = false
			$Timer.start()   # FIXED
	else:
		if player.Health < 100:
			player.Health += 1


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInside = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInside = false


func _on_timer_timeout() -> void:
	canDamage = true
