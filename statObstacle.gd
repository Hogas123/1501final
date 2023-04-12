extends Area2D


var id = "stat obstacle"

var mapPos = Vector2(0,0)
var dPointSize = 40
#node vars
var spr
var body
var exTimer

#custom signals
signal p_hitSignal
signal s_hitSignal(body, pos)


# Called when the node enters the scene tree for the first time.
func _ready():
	#get nodes
	spr = get_node("Sprite")
	exTimer = get_node("exTimer")
	
	
	#connect signals
	connect("p_hitSignal",get_tree().get_root().get_node("main") ,"goToTimelines")
	connect("s_hitSignal",get_tree().get_root().get_node("main") ,"shot_hit")
	
	position = Vector2( mapPos.x * dPointSize, mapPos.y * dPointSize)

func _on_statObstacle_body_entered(body):
	if body.id == "player":
		emit_signal("p_hitSignal")
	elif body.id == "shot":
		spr.set_frame(1)
		emit_signal("s_hitSignal", body, mapPos)
		exTimer.start()
		
func _on_exTimer_timeout():
	queue_free()
