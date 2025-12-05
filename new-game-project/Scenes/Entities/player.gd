extends CharacterBody2D

@export var Base_Speed = 300.0
@export var flySpeed : float = 400.0
var Speed = Base_Speed
var IsDead : bool = false
@export var Health : int
@export var isVampire : bool = true
@export var damage : float = 10
var canBite = true



func _physics_process(_delta: float) -> void:
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
		velocity = Vector2.ZERO

	if isVampire and velocity == Vector2.ZERO:
		$vampire.play("idle")

	else:
		$Bat.play("idle")
		
	move_and_slide()
	
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
		elif !isVampire:
			$BatCollision.disabled = false
			$VampireCollision.disabled = true
			isVampire = true
			Speed = Base_Speed
			$Bat.visible = false
			$vampire.visible = true

func bite():
	var enemy = get_tree().get_first_node_in_group("Enemy")
	if enemy:
		var enemyDistance = global_position.distance_to(enemy.global_position)
		if canBite:
			if enemy.is_in_group("Enemy"):
				enemy.getHurt(randf_range(40,60))
				$HitCooldown.start()
				canBite = false
	else:
		return

func getHurt(dmg:int):
	Health -= dmg
	if Health <= 0:
		die()
		
func die():
	$CanvasLayer/DeathScreen.show()
	get_tree().paused = true

func _on_hit_cooldown_timeout() -> void:
	canBite = true
