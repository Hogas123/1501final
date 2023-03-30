extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#sibling node vars
var player

#children node vars
var spr


# Called when the node enters the scene tree for the first time.
func _ready():
	#get sibling nodes
	player = get_parent().get_parent().get_node("PlayerBody")
	spr = get_node("Sprite")
	
	if player.pointing == "up":
		spr.set_frame(0)
		position = Vector2(player.position.x, player.position.y - 35)
	if player.pointing == "left":
		spr.set_frame(1)
		position = Vector2(player.position.x - 35, player.position.y)
	if player.pointing == "right":
		spr.set_frame(2)
		position = Vector2(player.position.x + 35, player.position.y)
	if player.pointing == "down":
		spr.set_frame(3)
		position = Vector2(player.position.x, player.position.y + 35)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
