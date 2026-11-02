extends RefCounted
class_name PlanetaryResourcesDto

var food: int
var minerals: int
var fuel: int
var processedMaterials: int

func fill(f:int,m:int,fu:int,p:int)->PlanetaryResourcesDto:
	food=f
	minerals=m
	fuel=fu
	processedMaterials=p
	return self
	

func subtract(subtrahend:PlanetaryResourcesDto) -> PlanetaryResourcesDto:
	food-=subtrahend.food
	minerals-=subtrahend.minerals
	fuel-=subtrahend.fuel
	processedMaterials-=subtrahend.processedMaterials
	return self

func add(addend:PlanetaryResourcesDto) -> PlanetaryResourcesDto:
	food+=addend.food
	minerals+=addend.minerals
	fuel+=addend.fuel
	processedMaterials+=addend.processedMaterials
	return self
	
func clipNegative() -> void:
	if(fuel<0):
		fuel=0
	if(food<0):
		food=0
	if(minerals<0):
		minerals=0
	if(processedMaterials<0):
		processedMaterials=0
