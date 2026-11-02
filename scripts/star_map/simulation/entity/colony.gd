extends RefCounted
class_name SimulationColony

var population: int
var infrastructure: float

var storage: PlanetaryResourcesDto
var economicsStructure: PlanetaryResourcesDto
var producedLastTick:PlanetaryResourcesDto
var consumedLastTick: PlanetaryResourcesDto
var resourceDefecit: PlanetaryResourcesDto

var claimingEmpire: SimulationEmpire
var parentPlanet: SimulationPlanet


signal destroyed

func _init() -> void:
	consumedLastTick=PlanetaryResourcesDto.new().fill(0,0,0,0)
	producedLastTick=PlanetaryResourcesDto.new().fill(0,0,0,0)
	resourceDefecit=PlanetaryResourcesDto.new().fill(0,0,0,0)

func consume() -> void:
	consumedLastTick.food=population*claimingEmpire.foodConsumption*parentPlanet.habitalityCoef

	consumedLastTick.minerals=population*getEconomicsStructureCoef(economicsStructure.processedMaterials)*claimingEmpire.refiningConsumption*parentPlanet.habitalityCoef
	consumedLastTick.fuel=claimingEmpire.infrastructureFuelConsumption*infrastructure
	consumedLastTick.processedMaterials=0
	storage.subtract(consumedLastTick)
	resourceDefecit.fill(0,0,0,0).subtract(storage).clipNegative()
	storage.clipNegative()
	
func produce() -> void:
	var effectiveInfrastructure=infrastructure	
	producedLastTick.fuel=population*getEconomicsStructureCoef(economicsStructure.fuel)*claimingEmpire.productivity*parentPlanet.fuelCoef*effectiveInfrastructure
	if(resourceDefecit.fuel>producedLastTick.fuel):
		effectiveInfrastructure*=1.0-(resourceDefecit.fuel-producedLastTick.fuel)/consumedLastTick.fuel
		producedLastTick.fuel=population*getEconomicsStructureCoef(economicsStructure.fuel)*claimingEmpire.productivity*parentPlanet.fuelCoef*effectiveInfrastructure
		
	producedLastTick.food=population*getEconomicsStructureCoef(economicsStructure.food)*claimingEmpire.productivity*parentPlanet.agricultureCoef*effectiveInfrastructure
	
	producedLastTick.minerals=population*getEconomicsStructureCoef(economicsStructure.minerals)*claimingEmpire.productivity*parentPlanet.miningCoef*effectiveInfrastructure
	
	if(economicsStructure.processedMaterials>0):
		var mineralSupplyCoef=1.0-(resourceDefecit.minerals-producedLastTick.minerals)/consumedLastTick.minerals
		if(mineralSupplyCoef>1):
			mineralSupplyCoef=1
		producedLastTick.processedMaterials=population*getEconomicsStructureCoef(economicsStructure.minerals)*claimingEmpire.productivity*mineralSupplyCoef*effectiveInfrastructure
	else:
		producedLastTick.processedMaterials=0
	
	storage.add(producedLastTick).subtract(resourceDefecit).clipNegative()
	resourceDefecit.subtract(producedLastTick).clipNegative()
	
func calcPopulation()-> void:
	if(population==parentPlanet.popCap && resourceDefecit.food==0):
		return
	var populationDelta=population*claimingEmpire.fertility
	if(resourceDefecit.food==0):
		population+=floor(populationDelta*parentPlanet.habitalityCoef)
	else:
		population-=floor(populationDelta*resourceDefecit.food/consumedLastTick.food*(1-parentPlanet.habitalityCoef))
	if(population>parentPlanet.popCap):
		population=parentPlanet.popCap
	if(population<=0):
		destroyed.emit()
		
	

func getEconomicsStructureCoef(industrySize:float) -> float:
	assert((economicsStructure.food+economicsStructure.fuel+economicsStructure.minerals+economicsStructure.processedMaterials) == 100)
	return industrySize/100
	
