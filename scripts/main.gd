extends Node

@export var starScene:PackedScene
@export var routeScene:PackedScene
@export var starPanelScene:PackedScene

@export_file("*.json") var testDataPath: String

var currentTick: int
var paused: bool
var simulation:GalaxySimulation


func tickWorld() -> void:
	currentTick=currentTick+1
	simulation.doTick(currentTick)
	get_node("InfoPanel").currentTick=currentTick
	


func _on_timer_timeout() -> void:
	if(!paused):
		tickWorld()

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("pause")):
		print('paused')
		paused=!paused

func _ready() -> void:
	simulation=GalaxySimulation.new()
	loadTestGalaxy()

func loadTestGalaxy() -> void:
	var file=FileAccess.open(testDataPath,FileAccess.READ)
	assert(file)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var testData=json.data
	var empire=createTestEmpire()
	get_node("InfoPanel").currentEmpire=empire
	var starsDict: Dictionary[String,StarView]
	for starData in testData['stars']:
		var star=createStar(starData['name'],starData['x'],starData['y'])
		starsDict.set(starData['id'],star)
		for planetData in starData['planets']:
			var planet=createPlanet(
				planetData['name'],
				planetData['population_limit'],
				planetData['agriculture_coefficient'],
				planetData['mining_coefficient'],
				planetData['fuel_coefficient'],
				planetData['habitability']
				)
			star.simulationObject.planets.append(planet)
			if(planetData['colony']!=null):
				var col=planetData['colony']
				createColony(
					empire,
					planet,
					col['starting_population'],
					col['infrastructure'],
					col['food_percent'],
					col['mining_percent'],
					col['fuel_percent'],
					col['processing_percent'],
					col['food_stock'],
					col['minerals_stock'],
					col['processed_metal_stock'],
					col['fuel_stock']
					)
	for route in testData['routes']:
		assert(starsDict.has(route['pointA']))
		assert(starsDict.has(route['pointB']))
		createRoute(starsDict[route['pointA']],starsDict[route['pointB']],route['length'])
	
func createStar(name: String,x: int, y: int) ->StarView:
	var logic=SimulationStar.new()
	var view=starScene.instantiate()
	logic.name=name
	view.position=Vector2(x,y)
	view.simulationObject=logic
	add_child(view)
	simulation.stars.append(logic)
	view.starSelected.connect(_on_selected_star)
	return view

func createPlanet(name:String,populationLimit:int,agriculture:float,minig:float,fuel:float,habitability:float) ->SimulationPlanet:
	var	planet=SimulationPlanet.new()
	planet.name=name
	planet.popCap=populationLimit
	planet.fuelCoef=fuel
	planet.agricultureCoef=agriculture
	planet.miningCoef=minig
	planet.habitalityCoef=habitability
	simulation.planets.append(planet)
	return planet

func createColony(empire:SimulationEmpire,planet:SimulationPlanet,population:int,infrastructure:float,foodEco:int,miningEco:int,fuelEco:int,processingEco:int,startingFood:int,startingMinerals:int,startingProcessed:int,startingFuel:int) -> void:
	var colony=SimulationColony.new()
	colony.population=population
	colony.infrastructure=infrastructure
	colony.claimingEmpire=empire
	empire.addColony(colony)
	colony.parentPlanet=planet
	planet.setColony(colony)
	colony.storage=PlanetaryResourcesDto.new().fill(startingFood,startingMinerals,startingFuel,startingProcessed)
	colony.economicsStructure=PlanetaryResourcesDto.new().fill(foodEco,miningEco,fuelEco,processingEco)
	simulation.addColony(colony)

func createRoute(pointA:StarView, pointB:StarView,length:int)->void:
	var routeData=WarpRouteData.new()
	routeData.length=length
	var starLinkA=WarpRoute.new()
	starLinkA.routeData=routeData
	starLinkA.routeDestination=pointB.simulationObject
	pointA.simulationObject.linkedRoutes.append(starLinkA)
	var starLinkB=WarpRoute.new()
	starLinkB.routeData=routeData
	starLinkB.routeDestination=pointA.simulationObject
	pointB.simulationObject.linkedRoutes.append(starLinkB)
	
	var routeView=routeScene.instantiate()
	routeView.pointA=pointA
	routeView.pointB=pointB
	routeView.routeData=routeData
	add_child(routeView)

func createTestEmpire()->SimulationEmpire:
	var empire=SimulationEmpire.new()
	empire.color=Color(255,0,0,255)
	empire.name='Великих Мемологов'
	empire.foodConsumption=1
	empire.fertility=100
	empire.productivity=4
	empire.infrastructureFuelConsumption=5
	empire.refiningConsumption=4
	simulation.empires.append(empire)
	return empire
	
func _on_selected_star(star: SimulationStar) -> void:
	get_node('InfoPanel').selectedStar=star
	


func _on_info_panel_open_star(star: SimulationStar) -> void:
	var panel=starPanelScene.instantiate()
	panel.setStar(star)
	add_child(panel)
