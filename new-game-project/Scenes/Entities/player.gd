extends CharacterBody2D

@export var Base_Speed = 300.0
@export var flySpeed : float = 400.0
var Speed = Base_Speed
var IsDead : bool = false
@export var Health : int
@export var isVampire : bool = false
@export var canHit : bool = true
@export var damage : float = 10
var canBeBitten = true
func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("go_left", "go_right", "go_up", "go_down")
	if direction:
		velocity = direction * Speed
		transform()
	else:
		velocity = Vector2.ZERO
		if isVampire:
			pass
		else:
			$Bat.play("idle")
	move_and_slide()
	
	if Input.is_action_just_pressed("hit"):
		bite()

func transform():
	if Input.is_action_just_pressed("transform"):
		if isVampire:
			Speed = flySpeed
			$Bat.visible = false
			$vampire.visible = true
			isVampire = false
		else:
			isVampire = true
			Speed = Base_Speed
			$Bat.visible = true
			$vampire.visible = false

func bite():
	if canBeBitten:
		if $HitArea.get_overlapping_bodies().size() > 0:
			for body in $HitArea.get_overlapping_bodies():
				if body.is_in_group("Enemy"):
					if canHit:
						body.getHurt()
						canHit = false
						$HitCooldown.start()
	else:
		return

func getHurt(dmg:int):
	Health -= dmg
	if Health <= 0:
		die()
		
func die():
	$CanvasLayer/DeathScreen.show()
	get_tree().paused = true
