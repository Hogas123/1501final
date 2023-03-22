extends Node2D

#essentials
var id = "main"
var screenSize 
var secondCount: float = 0.0
var dPointSize = 40
var n_xPos: int 
var n_yPos: int 
var map = []

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
var statObstacleScene
var endScreenScene






# Called when the node enters the scene tree for the first time.
func _ready():
	#setup
	screenSize = get_viewport().get_visible_rect().size
	n_xPos = floor(screenSize.x / dPointSize)
	n_yPos = floor(screenSize.y / dPointSize)
	
	#fill map empty
	for y in range(n_yPos):
		map.append([])
		for x in range(n_xPos):
			map[y].append("e")
			
	randomize()
	
	#get Godot Nodes
	root = get_node(".")
	timeLbl = get_node("StatsPan/TimeStat")
	scoreLbl = get_node("StatsPan/ScoreStat")
	player = get_node("PlayerBody")
	
	#preload scene instances
	deliveryPointScene = load("res://deliveryPoint.tscn")
	statObstacleScene = load("res://statObstacle.tscn")
	endScreenScene = load("res://endScreen.tscn")
	
	#load and place first delivery point
	deliveryPoint = deliveryPointScene.instance()
	root.add_child(deliveryPoint)
	deliveryPoint.position = randPointPlacer("d")
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	secondCount += delta
	if(secondCount > 0.1):
		secondCount = 0.0
		timer += 0.1
		timeLbl.text = "Time: " + str(timer)
	scoreLbl.text = "Score: " + str(score)
	

#Generates a random Point placement unoccupied point on the map
func randPointPlacer(type):
	#adjusted range keeps things out from behind ui and on screen
	var rand_xPos = randi() % (n_xPos-2) +1
	var rand_yPos = randi() % (n_yPos - 5) +3

	if map[rand_yPos][rand_xPos] == "e":
		map[rand_yPos][rand_xPos] = type
	else:
		#function reccurs until an empty space is chosen
		return randPointPlacer(type)
	return Vector2(rand_xPos * dPointSize, rand_yPos * dPointSize)
	
		
		
func score_increase():
	score += 1
	#clears the collected delivery point from the map
	for y in range(n_yPos):
		for x in range(n_xPos):
			if map[y][x] == "d":
				map[y][x] = "e"
				break
	
	#creates and maps new delivery point
	deliveryPoint = deliveryPointScene.instance()
	root.add_child(deliveryPoint)
	deliveryPoint.position = randPointPlacer("d")
	
	#creates and maps new obstacle
	var inst = statObstacleScene.instance()
	root.add_child(inst)
	inst.position = randPointPlacer("o")
	
#shows end screen
func death():
	var inst = endScreenScene.instance()
	root.add_child(inst)
	
#prevents entering ui
func _on_statsPanArea_body_entered(body):
	player.collisionDirection()

#returns movement once away from ui
func _on_statsPanArea_body_exited(body):
	player.motionReset()
