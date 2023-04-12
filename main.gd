#LoganCarrell 101181953
extends Node2D

#essentials
var id = "main"
var screenSize 
var secondCount: float = 0.0
var dPointSize = 40
var n_xPos: int 
var n_yPos: int 
var map = []
var garbage = []

#game vars
var score = 0
var timer = 0
var ammo = 30
var lines = 0
var playtime = 0

#Godot node variables
var root
var timeLbl
var scoreLbl 
var ammoLbl
var deliveryPoint
var player
var playspace

#Instanced secne Preloads
var deliveryPointScene
var statObstacleScene
var emitterObstacleScene
var timelinesScreenScene
var endScreenScene
var shotScene
var playerScene
var projectileScene






# Called when the node enters the scene tree for the first time.
func _ready():
	#setup
	screenSize = get_viewport().get_visible_rect().size
	n_xPos = floor(screenSize.x / dPointSize)
	n_yPos = floor(screenSize.y / dPointSize)
			
	randomize()
	
	#get Godot Nodes
	root = get_node(".")
	playspace = get_node("playspace")
	timeLbl = get_node("StatsPan/TimeStat")
	scoreLbl = get_node("StatsPan/ScoreStat")
	ammoLbl = get_node("StatsPan/AmmoCount")
	
	
	#preload scene instances
	deliveryPointScene = load("res://deliveryPoint.tscn")
	statObstacleScene = load("res://statObstacle.tscn")
	emitterObstacleScene = load ("res://ProjectileEmitter.tscn")
	timelinesScreenScene = load("res://TimelinesScreen.tscn")
	playerScene = load("res://PlayerBody.tscn")
	shotScene = load("res://PlayerShot.tscn")
	projectileScene = load("res://Projectile.tscn")
	endScreenScene = load("res://gameOverScreen.tscn")
	start_playspace()

	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	secondCount += delta
	if(secondCount > 0.1):
		secondCount = 0.0
		timer += 0.1
		timeLbl.text = "Time: " + str(timer)
	scoreLbl.text = "Score: " + str(score)
	ammoLbl.text = "Ammo: " + str(ammo)
	
	
	var shooting = false
	
	if Input.is_action_just_pressed("playerShoot") and ammo > 0:
		var inst = shotScene.instance()
		playspace.add_child(inst)
		ammo -= 1
	
	if Input.is_action_just_pressed("map"):
		print(map)
	
func start_playspace():
	#fill map empty
	for y in range(n_yPos):
		map.append([])
		for x in range(n_xPos):
			map[y].append("e")
	
	
	player = playerScene.instance()
	playspace.add_child(player)
	#load and place first delivery point
	deliveryPoint = deliveryPointScene.instance()
	playspace.add_child(deliveryPoint)
	var newDPos = randPointPlacer("d")
	deliveryPoint.position.x = newDPos.x * dPointSize
	deliveryPoint.position.y = newDPos.y * dPointSize
	
func reset_playspace():
	for x in playspace.get_children():
		print(x)
		x.queue_free()
	
	ammo = 7
	start_playspace()

func randomize_playspace():
	reset_playspace()
	var num_obs
	#provides maximum number of objects in a new timeline 
	if score > 20:
		num_obs = 20
	else:
		num_obs = score
	for x in num_obs:
		#creates and maps new obstacle
		var type_it = x+1
		if(type_it % 7 == 0):
			var inst = emitterObstacleScene.instance()
			inst.mapPos = randPointPlacer("o_e")
			inst.multi = true
			playspace.add_child(inst)
		elif(type_it % 3 == 0):
			var inst = emitterObstacleScene.instance()
			inst.mapPos = randPointPlacer("o_e")
			playspace.add_child(inst)
		else:
			var inst = statObstacleScene.instance()
			inst.mapPos = randPointPlacer("o_s")
			playspace.add_child(inst)
	

func goToTimelines():
	lines += 1
	var inst = timelinesScreenScene.instance()
	add_child(inst)
	get_tree().paused =  true
	
func gameOver():
	var inst = endScreenScene.instance()
	add_child(inst)
	
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
	return Vector2(rand_xPos , rand_yPos)
	
		
		
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
	playspace.add_child(deliveryPoint)
	var newDPos = randPointPlacer("d")
	deliveryPoint.position.x = newDPos.x * dPointSize
	deliveryPoint.position.y = newDPos.y * dPointSize
	
	#creates and maps new obstacle
	if(score % 7 == 0):
		var inst = emitterObstacleScene.instance()
		inst.mapPos = randPointPlacer("o_e")
		inst.multi = true
		playspace.add_child(inst)
	elif(score % 3 == 0):
		var inst = emitterObstacleScene.instance()
		inst.mapPos = randPointPlacer("o_e")
		playspace.add_child(inst)
	else:
		var inst = statObstacleScene.instance()
		inst.mapPos = randPointPlacer("o_s")
		playspace.add_child(inst)
	
func shot_hit(body, pos):
	
	map[pos.y][pos.x] = "e"
	body.queue_free()
	
func emit_proj(direction, pos):
	var inst = projectileScene.instance()
	
	if direction != "multi":
		if direction == "up":
			inst.direction = "up"
			inst.position.x = pos.x
			inst.position.y = pos.y - 35
		elif direction == "left":
			inst.direction = "left"
			inst.position.x = pos.x - 35
			inst.position.y = pos.y
		elif direction == "right":
			inst.direction = "right"
			inst.position.x = pos.x + 35
			inst.position.y = pos.y 
		elif direction == "down":
			inst.direction = "down"
			inst.position.x = pos.x
			inst.position.y = pos.y + 35
		playspace.add_child(inst)
	else:
		inst.direction = "up"
		inst.position.x = pos.x
		inst.position.y = pos.y - 35
		playspace.add_child(inst)
		inst = projectileScene.instance()
		inst.direction = "left"
		inst.position.x = pos.x - 35
		inst.position.y = pos.y
		playspace.add_child(inst)
		inst = projectileScene.instance()
		inst.direction = "right"
		inst.position.x = pos.x + 35
		inst.position.y = pos.y 
		playspace.add_child(inst)
		inst = projectileScene.instance()
		inst.direction = "down"
		inst.position.x = pos.x
		inst.position.y = pos.y + 35
		playspace.add_child(inst)
		
func proj_hit(body):
	print("struck")
	if body.id == "player":
		goToTimelines()
		
#prevents entering ui
func _on_statsPanArea_body_entered(body):
	player.collisionDirection()

#returns movement once away from ui
func _on_statsPanArea_body_exited(body):
	player.motionReset()

#destroys off screen items to help performance
func _on_playspace_body_exited(body):
	body.queue_free()
	pass # Replace with function body.
