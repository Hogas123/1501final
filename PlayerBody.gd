extends KinematicBody2D

var id = "player"

var speed = 15
var pointing

var canLeft = true
var canRight = true
var canUp = true
var canDown = true
var colliding = false

#node vars
var spr



# Called when the node enters the scene tree for the first time.
func _ready():
	#get nodes
	spr = get_node("Sprite")
	pointing = "up"
	position = Vector2(500,550)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if position.x > get_viewport().get_visible_rect().size.x - 40:
		canRight = false
	elif !colliding:
		canRight = true
	if position.x < 40:
		canLeft = false
	elif !colliding:
		canLeft = true
	if position.y > get_viewport().get_visible_rect().size.y - 40:
		canDown = false
	elif !colliding:
		canDown = true
	if position.y < 40:
		canUp = false
	elif !colliding:
		canUp = true
		
		
	if Input.is_action_pressed("ui_right") and canRight:
		spr.set_frame(3) 
		position.x+=20*speed*delta
		pointing = "right"
		
	if Input.is_action_pressed("ui_left") and canLeft:
		spr.set_frame(2)
		position.x-=20*speed*delta
		pointing = "left"
		
	if Input.is_action_pressed("ui_up") and canUp:
		spr.set_frame(0)
		position.y-=20*speed*delta
		pointing = "up"
		
	if Input.is_action_pressed("ui_down") and canDown:
		spr.set_frame(1)
		position.y+=20*speed*delta
		pointing = "down"
	
	





func collisionDirection():
	colliding = true
	if Input.is_action_pressed("ui_right"):
		canRight = false
		
	if Input.is_action_pressed("ui_left"):
		canLeft = false
		
	if Input.is_action_pressed("ui_up"):
		canUp = false
		
	if Input.is_action_pressed("ui_down"):
		canDown = false
		



func motionReset():
	canDown = true
	canUp = true
	canLeft = true
	canRight = true
	colliding = false
