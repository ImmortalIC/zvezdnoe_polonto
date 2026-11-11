extends RefCounted
class_name SimulationColony

var population: int
var infrastructure: float

var storage: PlanetaryResourcesDto
var economicsStructure: PlanetaryResourcesDto
var producedLastTick:PlanetaryResourcesDto
var consumedLastTick: PlanetaryResourcesDto
var resourceDefecit: PlanetaryResourcesDto
var exportedLastTick: PlanetaryResourcesDto
var importedLastTick: PlanetaryResourcesDto

var claimingEmpire: SimulationEmpire
var parentPlanet: SimulationPlanet

var storageCap:int
var percentStorageToStartExport: int

signal destroyed

func _init() -> void:
	consumedLastTick=PlanetaryResourcesDto.new().fill(0,0,0,0)
	producedLastTick=PlanetaryResourcesDto.new().fill(0,0,0,0)
	resourceDefecit=PlanetaryResourcesDto.new().fill(0,0,0,0)
	importedLastTick=PlanetaryResourcesDto.new()
	exportedLastTick=PlanetaryResourcesDto.new()

func consume() -> void:
	consumedLastTick.food=population*claimingEmpire.foodConsumption*(2-parentPlanet.habitalityCoef)

	consumedLastTick.minerals=population*getEconomicsStructureCoef(economicsStructure.processedMaterials)*claimingEmpire.refiningConsumption*(2-parentPlanet.habitalityCoef)
	consumedLastTick.fuel=claimingEmpire.infrastructureFuelConsumption*infrastructure*(2-parentPlanet.habitalityCoef)
	consumedLastTick.processedMaterials=0
	storage.subtract(consumedLastTick)
	resourceDefecit.fill(0,0,0,0).subtract(storage).clipNegative()
	storage.clipNegative()
	
func produce() -> void:
	var effectiveInfrastructure=infrastructure	
	producedLastTick.fuel=population*getEconomicsStructureCoef(economicsStructure.fuel)*claimingEmpire.productivity*parentPlanet.fuelCoef*effectiveInfrastructure
	if(resourceDefecit.fuel>producedLastTick.fuel && consumedLastTick.fuel>0):
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

func buildTradeData()->void:
	var export=PlanetaryResourcesDto.new()
	var exportThreshold=storageCap*percentStorageToStartExport/100
	export.food=calcExport(storage.food,producedLastTick.food-consumedLastTick.food,exportThreshold)
	export.minerals=calcExport(storage.minerals,producedLastTick.minerals-consumedLastTick.minerals,exportThreshold)
	export.fuel=calcExport(storage.fuel,producedLastTick.fuel-consumedLastTick.fuel,exportThreshold)
	export.processedMaterials=calcExport(storage.processedMaterials,producedLastTick.processedMaterials-consumedLastTick.processedMaterials,exportThreshold)
	var tradeDeficit=PlanetaryResourcesDto.new().fill(consumedLastTick.food,consumedLastTick.minerals,consumedLastTick.fuel,consumedLastTick.processedMaterials).subtract(producedLastTick)
	tradeDeficit.clipNegative()
	parentPlanet.parentStar.systemExport.append(PlanetaryTrade.create(export,self))
	parentPlanet.parentStar.systemDeficit.append(PlanetaryTrade.create(tradeDeficit,self))
	importedLastTick.fill(0,0,0,0)
	exportedLastTick.fill(0,0,0,0)

func calcExport(resource:int,producedResource:int,threshold:int)->int:
	if resource<threshold || producedResource<0:
		return 0
	if(resource-threshold)>producedResource:
		return producedResource
	else:
		return resource-threshold

func exportFood(num:int)->void:
	storage.food-=num
	exportedLastTick.food+=num
	
func importFood(num:int)->void:
	if(resourceDefecit.food<num):
		storage.food+=(num-resourceDefecit.food)
	resourceDefecit.food-=num
	importedLastTick.food-=num
	
func exportMinerals(num:int)->void:
	storage.minerals-=num
	exportedLastTick.minerals+=num
	
func importMinerals(num:int)->void:
	storage.minerals+=num
	importedLastTick.food-=num
	
func exportFuel(num:int)->void:
	storage.fuel-=num
	exportedLastTick.fuel+=num
	
func importFuel(num:int)->void:
	storage.fuel+=num
	importedLastTick.fuel-=num
	
func exportMetals(num:int)->void:
	storage.processedMaterials-=num
	exportedLastTick.processedMaterials+=num
	
func importMetals(num:int)->void:
	storage.processedMaterials+=num
	importedLastTick.processedMaterials-=num
