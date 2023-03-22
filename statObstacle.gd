extends Area2D


var id = "stat obstacle"
var valid = true

signal hitSignal


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("hitSignal",get_tree().get_root().get_node("main") ,"death")
	


func _on_statObstacle_body_entered(body):
	emit_signal("hitSignal")
