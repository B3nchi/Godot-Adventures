extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	esc()

func resume():
	get_tree().paused = false
	
func pause():
	get_tree().paused = true
	
func esc():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	if Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()


func _on_resume_pressed() -> void:
	resume()


func _on_quit_pressed() -> void:
	get_tree().quit
