extends RefCounted
class_name GalaxySimulation

var stars:Array[SimulationStar]
var planets:Array[SimulationPlanet]
var colonies:Array[SimulationColony]
var empires:Array[SimulationEmpire]
var colonyIndexValid=true


func doTick(tickNum:int)->void:
	for colony in colonies:
		colony.consume()
		colony.produce()
		colony.buildTradeData()
		
	for star in stars:
		star.processSystemTrade()
		#TODO: обработка межзвездных перевозок
		star.cleanUpTradeData()
		
	for colony in colonies:
		colony.calcPopulation()
		
	if !colonyIndexValid:
		rebuildColonyIndex()


func addColony(colony:SimulationColony)->void:
	colonies.append(colony)
	colony.destroyed.connect(_on_colony_destroyed.bind(colony))
	


func _on_colony_destroyed(colony:SimulationColony)->void:
	colonyIndexValid=false

func rebuildColonyIndex()->void:
	colonies.clear()
	for star in stars:
		for planet in star.planets:
			if(planet.colony!=null):
				addColony(planet.colony)
	colonyIndexValid=true
