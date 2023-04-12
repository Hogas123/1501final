extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var instrScreenScene


# Called when the node enters the scene tree for the first time.
func _ready():
	instrScreenScene = load("res://InstrScreen.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	queue_free()
	get_parent().started = true
	get_parent().start_playspace()


func _on_instructions_pressed():
	var inst = instrScreenScene.instance()
	get_parent().add_child(inst)
