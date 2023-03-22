extends Area2D


var id = "delivery point"
var valid = true

signal scoreSignal


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("scoreSignal",get_tree().get_root().get_node("main") ,"score_increase")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_deliveryPoint_body_entered(body):
	emit_signal("scoreSignal")
	queue_free()
