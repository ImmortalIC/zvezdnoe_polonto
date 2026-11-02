extends RefCounted
class_name GalaxySimulation

var stars:Array[SimulationStar]
var planets:Array[SimulationPlanet]
var colonies:Array[SimulationColony]
var empires:Array[SimulationEmpire]


func doTick(tickNum:int)->void:
	for colony in colonies:
		colony.consume()
		colony.produce()
		colony.calcPopulation()

func addColony(colony:SimulationColony)->void:
	colonies.append(colony)
	colony.destroyed.connect(_on_colony_destroyed.bind(colony))
	


func _on_colony_destroyed(colony:SimulationColony)->void:
	colonies.erase(colony)
