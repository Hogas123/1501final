extends KinematicBody2D

var id = "shot"
# Shot vars
var direction
var speed = 20


#sibling node vars
var player

#children node vars
var spr
var playspace

# Called when the node enters the scene tree for the first time.
func _ready():
	#get sibling nodes
	playspace = get_parent()
	spr = get_node("Sprite")
	print(playspace.playerDir)
	if playspace.playerDir == "up":
		spr.set_frame(0)
		position = Vector2(playspace.playerPos.x, playspace.playerPos.y - 35)
		direction = "up"
	if playspace.playerDir == "left":
		spr.set_frame(1)
		position = Vector2(playspace.playerPos.x - 35, playspace.playerPos.y)
		direction = "left"
	if playspace.playerDir == "right":
		spr.set_frame(2)
		position = Vector2(playspace.playerPos.x + 35, playspace.playerPos.y)
		direction = "right"
	if playspace.playerDir == "down":
		spr.set_frame(3)
		position = Vector2(playspace.playerPos.x, playspace.playerPos.y + 35)
		direction = "down"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction == "up":
		position.y -= 20*speed*delta
	if direction == "left":
		position.x -= 20*speed*delta
	if direction == "right":
		position.x += 20*speed*delta
	if direction == "down":
		position.y += 20*speed*delta


