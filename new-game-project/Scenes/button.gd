extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	$"../../AnimationPlayer".play("fade")
	$"..".visible = false
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_file("res://Scripts/Maps/Demo.tscn")


func _on_mouse_entered() -> void:
	add_theme_font_size_override("font_size", 35)


func _on_mouse_exited() -> void:
	add_theme_font_size_override("font_size", 25)
