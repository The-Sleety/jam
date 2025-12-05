extends CharacterBody2D


var Speed = randf_range(20, 50)
var canHit = true
var PlayerBody = null
var damage = randi_range(10,20)
var cooldown = 2.4
var maxHealth = randi_range(100,120)
var health = maxHealth

func _physics_process(_delta: float) -> void:
	position += (get_tree().get_first_node_in_group("Player").global_position - position) / Speed
	move_and_slide()

	if $HitArea.get_overlapping_bodies().size() > 0:
		for body in $HitArea.get_overlapping_bodies():
			if body.is_in_group("Player"):
				if canHit:
					body.getHurt(damage)
					canHit = false
					$HitCooldown.start()


func _on_hit_cooldown_timeout() -> void:
	canHit = true
