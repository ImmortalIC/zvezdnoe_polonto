extends RefCounted
class_name SimulationPlanet

var popCap: int
var agricultureCoef: float
var miningCoef: float
var fuelCoef: float
var habitalityCoef: float
var name: String
var colony: SimulationColony

func setColony(newColony:SimulationColony)->SimulationPlanet:
	colony=newColony
	colony.destroyed.connect(_on_colony_destroyed)
	return self

func _on_colony_destroyed()->void:
	colony=null
