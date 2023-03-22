extends Node2D

#essentials
var id = "main"
var screenSize 
var secondCount: float = 0.0
var dPointSize = 32

#game vars
var score = 0
var timer = 0

#Godot node variables
var root
var timeLbl
var scoreLbl 
var deliveryPoint
var player

#Instanced secne Preloads
var deliveryPointScene




# Called when the node enters the scene tree for the first time.
func _ready():
	#setup
	screenSize = get_viewport().get_visible_rect().size
	randomize()
	
	#get Godot Nodes
	root = get_node(".")
	timeLbl = get_node("StatsPan/TimeStat")
	scoreLbl = get_node("StatsPan/ScoreStat")
	player = get_node("PlayerBody")
	
	#preload scene instances
	deliveryPointScene = load("res://deliveryPoint.tscn")
	
	
	#load and place first delivery point
	deliveryPoint = deliveryPointScene.instance()
	root.add_child(deliveryPoint)
	deliveryPoint.position = randDPointPlacer()
	
	
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	secondCount += delta
	if(secondCount > 0.1):
		secondCount = 0.0
		timer += 0.1
		timeLbl.text = "Time: " + str(timer)
	scoreLbl.text = "Score: " + str(score)
	

#Generates a random dPoint placement on the map
func randDPointPlacer():
	var n_xPos: int = floor(screenSize.x / dPointSize)
	var n_yPos: int = floor(screenSize.y / dPointSize)
	
	var rand_xPos = randi() % (n_xPos-2) +1
	var rand_yPos = randi() % (n_yPos-2) +1
	#Keeps points out of behind ui
	if rand_xPos > n_xPos - 5 and rand_yPos < 3:
		randDPointPlacer()
	print(Vector2(rand_xPos * dPointSize, rand_yPos * dPointSize))
	return Vector2(rand_xPos * dPointSize, rand_yPos * dPointSize)
	
func _on_statsPanArea_body_entered(body):
	print("invaded")
	if body.id == "player":
		player.collisionDirection()
		
func _on_statsPanArea_body_exited(body):
	if body.id == "player":
		player.motionReset()
		
		
func score_increase():
	score += 1
	deliveryPoint = deliveryPointScene.instance()
	root.add_child(deliveryPoint)
	deliveryPoint.position = randDPointPlacer()
	





