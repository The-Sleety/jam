extends CharacterBody2D

@export var Base_Speed = 300.0
@export var flySpeed : float = 400.0
var Speed = Base_Speed
var IsDead : bool = false
@export var Health : float
@export var isVampire : bool = true
@export var damage : float 

var knockback : Vector2 = Vector2.ZERO
var knockback_timer : float = 0.0

var canBite = true
var enemies_in_range = []

var score = 0000
func _ready() -> void:
	$Camera2D.zoom = Vector2(0.1,0.1)
	$Camera2D.zoom = Vector2(1,1)

func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
				knockback = Vector2.ZERO
	else:
		var direction := Input.get_vector("go_left", "go_right", "go_up", "go_down")
		if direction:
			velocity = direction * Speed
			if isVampire:
				if direction == Vector2.LEFT:
					$vampire.flip_h = true
					$vampire.play("right")
				elif direction == Vector2.RIGHT:
					$vampire.flip_h = false
					$vampire.play("right")
				elif direction == Vector2.UP:
					$vampire.play("back")
				elif direction == Vector2.DOWN:
					$vampire.play("up")
			else:
				Health -= 0.1
		else:
			velocity = Vector2.ZERO
		if isVampire and velocity == Vector2.ZERO:
			$vampire.play("idle")

		else:
			$Bat.play("idle")
		
	move_and_slide()
	
	
	$CanvasLayer/SCORE.text = 'SCORE: ' + str(score)
	
	if Input.is_action_just_pressed("hit"):
		bite()
		
	if Input.is_action_just_pressed("transform"):
		transform()
		
	

func transform():
		if isVampire:
			$VampireCollision.disabled = false
			$BatCollision.disabled = true
			Speed = flySpeed
			$Bat.visible = true
			$vampire.visible = false
			isVampire = false
			damage = 30
			$Flap.stop()
			$Walk.play()
		elif !isVampire:
			$BatCollision.disabled = false
			$VampireCollision.disabled = true
			isVampire = true
			Speed = Base_Speed
			$Bat.visible = false
			$vampire.visible = true
			$Flap.play()
			$Walk.stop()

func _on_BiteArea_area_entered(area):
	# area is the Enemy.Hurtbox Area2D
	var parent = area.get_parent()
	if parent and parent.is_in_group("Enemy"):
		enemies_in_range.append(parent)

func _on_BiteArea_area_exited(area):
	var parent = area.get_parent()
	if parent and parent.is_in_group("Enemy"):
		enemies_in_range.erase(parent)

func bite():
	if not isVampire or not canBite:
		return
	if enemies_in_range.size() == 0:
		return
	var enemy = enemies_in_range[0]
	canBite = false
	damage_number(damage, Vector2(enemy.global_position.x, enemy.global_position.y))
	$vampire.play("biting")
	enemy.getHurt(randf_range(40, 60))
	score += 5
	$HitCooldown.start()
	$Hit.play()

func getHurt(dmg:int):
	Health -= dmg
	if Health <= 0:
		die()
		
func die():
	$CanvasLayer/DeathScreen.show()
	$Death.play()
	get_tree().paused = true

func _on_hit_cooldown_timeout() -> void:
	canBite = true

func apply_knockback(direction : Vector2,force : float,knockback_duration : float):
	knockback = direction * force
	knockback_timer = knockback_duration

func damage_number(amount: int, position: Vector2):
	# Create a label on the fly 
	var label := Label.new()
	label.text = str(amount)
	label.position = position
	label.modulate = Color(1, 1, 1, 1)
	label.add_theme_color_override("font_color", Color.WHITE_SMOKE)

	# Add to current scene
	get_tree().current_scene.add_child(label)

	# Make it float + fade + delete
	var tween := label.create_tween()
	tween.set_parallel()

	# Float upward
	tween.tween_property(label, "position:y", position.y - 40, 0.5)

	# Fade out
	tween.tween_property(label, "modulate:a", 0.0, 0.5)

	# Remove when finished
	tween.finished.connect(label.queue_free)
