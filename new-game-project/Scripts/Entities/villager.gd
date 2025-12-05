extends CharacterBody2D


var Speed = randf_range(20, 50)
var canHit = true
var cooldown = 2.4
var maxHealth = randf_range(80,120)
var Health = maxHealth
var canMove = true

func _physics_process(_delta: float) -> void:
	if canMove:
		#position += (get_tree().get_first_node_in_group("Player").global_position - position) / Speed
		pass
		
	if $HitArea.get_overlapping_bodies().size() > 0:
		for body in $HitArea.get_overlapping_bodies():
			if body.is_in_group("Player"):
				if canHit:
					var damage = randi_range(10,20)
					body.getHurt(damage)
					canHit = false
					$HitCooldown.start()
	move_and_slide()


	

func getHurt(Damage : int ):
	canMove = false
	canHit = false
	$HitResultCooldown.start()
	Health-=Damage
	if Health <= 0:
		queue_free()


	
func _on_hit_cooldown_timeout() -> void:
	canHit = true

func _on_hit_result_cooldown_timeout() -> void:
	canMove = true
	canHit = true
	
