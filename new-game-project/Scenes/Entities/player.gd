extends CharacterBody2D

@export var Base_Speed = 300.0
var Speed = Base_Speed
@export var Health : int

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("go_left", "go_right", "go_up", "go_down")
	if direction:
		velocity = direction * Speed
	else:
		velocity = Vector2.ZERO

	if Input.is_action_just_pressed("hurt"):
		getHurt(25);
	
	move_and_slide()

func getHurt(dmg:int):
	clamp(Health ,0, 100)
	Health -= dmg
