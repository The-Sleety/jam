extends CharacterBody2D


var Speed = randf_range(20, 50)
var canHit = true
var PlayerBody = null
var damage = randi_range(10,20)
var cooldown = 2.4
var maxHealth = 1
var Health = maxHealth
var canMove = true
func _physics_process(_delta: float) -> void:
	if canMove:
		position += (get_tree().get_first_node_in_group("Player").global_position - position) / Speed
	move_and_slide()

	if $HitArea.get_overlapping_bodies().size() > 0:
		for body in $HitArea.get_overlapping_bodies():
			if body.is_in_group("Player"):
				if canHit:
					body.getHurt(damage)
					canHit = false
					$HitCooldown.start()

func getHurt():
	canMove = false
	
	canHit = false
	await get_tree().create_timer(2.5).timeout
	queue_free()

func _on_hit_cooldown_timeout() -> void:
	canHit = true
