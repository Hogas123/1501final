extends Area2D


var id = "projectile emitter"

var direction
var mapPos = Vector2(0,0)
var dPointSize = 40
#node vars
var spr
var body
var exTimer

#Scene vars


#custom signals
signal p_hitSignal
signal s_hitSignal(body, pos)
signal emit_projSignal(direction, pos)


# Called when the node enters the scene tree for the first time.
func _ready():
	#get nodes
	spr = get_node("Sprite")
	exTimer = get_node("exTimer")
	var getDir = randi() % 4
	
	if getDir == 0:
		direction = "up"
		spr.set_frame(0)
	elif getDir == 1:
		direction = "left"
		spr.set_frame(1)
	elif getDir == 2:
		direction = "right"
		spr.set_frame(2)
	elif getDir == 3:
		direction = "down"
		spr.set_frame(3)
	#connect signals
	connect("p_hitSignal",get_tree().get_root().get_node("main") ,"death")
	connect("s_hitSignal",get_tree().get_root().get_node("main") ,"shot_hit")
	connect("emit_projSignal",get_tree().get_root().get_node("main") ,"emit_proj")
	
	position = Vector2( mapPos.x * dPointSize, mapPos.y * dPointSize)

		
func _on_exTimer_timeout():
	queue_free()


func _on_ProjectileEmitter_body_entered(body):
	if body.id == "player":
		emit_signal("p_hitSignal")
	elif body.id == "shot":
		spr.set_frame(4)
		emit_signal("s_hitSignal", body, mapPos)
		exTimer.start()


func _on_emitTimer_timeout():
	emit_signal("emit_projSignal", direction, position)
