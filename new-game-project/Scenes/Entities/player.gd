extends CharacterBody2D

@export var Base_Speed = 300.0
@export var flySpeed : float = 400.0
var Speed = Base_Speed
var IsDead : bool = false
@export var Health : int
@export var isVampire : bool = true
@export var damage : float = 10
var canBite = true
@export var knocback_strength: int = 5



func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("go_left", "go_right", "go_up", "go_down")
	if direction:
		velocity = direction * Speed
	else:
		velocity = Vector2.ZERO
		if isVampire:
			$vampire.play("idle")
		else:
			$Bat.play("idle")
	move_and_slide()
	
	if Input.is_action_just_pressed("hit"):
		bite()
	
	if Input.is_action_just_pressed("transform"):
		transform()
	print(velocity)

func transform():
		if isVampire:
			$VampireCollision.disabled = false
			$BatCollision.disabled = true
			Speed = flySpeed
			$Bat.visible = false
			$vampire.visible = true
			isVampire = false
		else:
			$BatCollision.disabled = false
			$VampireCollision.disabled = true
			isVampire = true
			Speed = Base_Speed
			$Bat.visible = true
			$vampire.visible = false

func bite():
	if canBite:
		if $HitArea.get_overlapping_bodies().size() > 0:
			for body in $HitArea.get_overlapping_bodies():
				if body.is_in_group("Enemy"):
						body.getHurt(randf_range(40,60))
						print(body.Health)
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
