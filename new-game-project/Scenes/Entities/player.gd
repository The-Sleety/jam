extends CharacterBody2D

@export var Base_Speed = 300.0
@export var flySpeed : float = 400.0
var Speed = Base_Speed
var IsDead : bool = false
@export var Health : int
@export var isVampire : bool = false


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

func transform():
	if Input.is_action_just_pressed("ui_accept"):
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
	#if is in area and prey health is less than a amount be able to bite 
	pass

func getHurt(dmg:int):
	Health -= dmg
	if Health <= 0:
		die()
		
func die():
	$CanvasLayer/DeathScreen.show()
	get_tree().paused = true
