extends Area2D

var id = "projectile"
# Shot vars
var direction
var speed = 5

#children node vars
var spr

signal projectile_hitSignal(body)

# Called when the node enters the scene tree for the first time.
func _ready():
	#get sibling nodes
	spr = get_node("Sprite")
	connect("projectile_hitSignal",get_tree().get_root().get_node("main") ,"proj_hit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction == "up":
		spr.set_frame(0)
		position.y -= 20*speed*delta
	if direction == "left":
		spr.set_frame(1)
		position.x -= 20*speed*delta
	if direction == "right":
		spr.set_frame(2)
		position.x += 20*speed*delta
	if direction == "down":
		spr.set_frame(3)
		position.y += 20*speed*delta




func _on_Projectile_body_entered(body):
	emit_signal("projectile_hitSignal", body)
	queue_free()
	
