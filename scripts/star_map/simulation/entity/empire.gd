extends RefCounted
class_name SimulationEmpire

var productivity: float
var fertility: float
var foodConsumption: float
var infrastructureFuelConsumption: int
var refiningConsumption: int
var name: String
var color:Color
var colonies: Array[SimulationColony]


func addColony(colony:SimulationColony)->void:
	colonies.append(colony)
	colony.destroyed.connect(_on_colony_destroyed.bind(colony))
	


func _on_colony_destroyed(colony:SimulationColony)->void:
	colonies.erase(colony)
