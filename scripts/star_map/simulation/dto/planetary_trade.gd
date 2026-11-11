extends RefCounted
class_name PlanetaryTrade

var resources: PlanetaryResourcesDto
var colony: SimulationColony

static func create(r:PlanetaryResourcesDto,c:SimulationColony)->PlanetaryTrade:
	var instance=PlanetaryTrade.new()
	instance.colony=c
	instance.resources=r
	return instance
