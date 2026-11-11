extends Control
class_name PlanetPanel
var selectedStar:SimulationStar
var selectedPlanet:SimulationPlanet
@export var planetScene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setStar(st:SimulationStar)->PlanetPanel:
	selectedStar=st
	var grid=get_node("PlanetGrid")
	grid.size[0]=105*selectedStar.planets.size()
	for planet in selectedStar.planets:
		var planetView=planetScene.instantiate()
		planetView.simulationObject=planet
		grid.add_child(planetView)
		planetView.selectPlanet.connect(_on_selected_planet)
	
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_node("StarName").text=selectedStar.name
	if(selectedPlanet==null):
		get_node("PlanetStatsContainer").visible=false
		get_node("PlanetName").visible=false
		get_node("PlanetState").visible=false
		get_node("ColonyStatsContainer").visible=false
		return
	get_node("PlanetStatsContainer").visible=true
	get_node("PlanetName").visible=true
	get_node("PlanetState").visible=true
	get_node("PlanetName").text=selectedPlanet.name
	
	get_node("PlanetStatsContainer/MaxPop/Label").text="Максимальное население {0}".format([str(selectedPlanet.popCap)])
	get_node("PlanetStatsContainer/FoodCoeficient/Label").text="Плодородность {0}".format([str(selectedPlanet.agricultureCoef)])
	get_node("PlanetStatsContainer/MiningCoeficient/Label").text="Богатство Минералами {0}".format([str(selectedPlanet.miningCoef)])
	get_node("PlanetStatsContainer/FuelCoeficient/Label").text="Богатство энергоносителями {0}".format([str(selectedPlanet.fuelCoef)])
	get_node("PlanetStatsContainer/Habitability/Label").text="Коэфициент обитаемости {0}".format([str(selectedPlanet.habitalityCoef)])
	if(selectedPlanet.colony==null):
		get_node("ColonyStatsContainer").visible=false
		get_node("PlanetState").text="Незаселенная планета"
		return
	var colony:=selectedPlanet.colony
	get_node("PlanetState").text="Колония империи {0}".format([colony.claimingEmpire.name])
	get_node("ColonyStatsContainer").visible=true
	get_node("ColonyStatsContainer/Col1/Population/Label").text=str(colony.population)
	get_node("ColonyStatsContainer/Col1/Infrastructure/Label").text="Инфраструктура {0}%".format([str(colony.infrastructure*100)])
	
	get_node("ColonyStatsContainer/Col1/FoodEconomics/Label").text="{0}%".format([str(colony.economicsStructure.food)])
	get_node("ColonyStatsContainer/Col1/MiningEconomics/Label").text="{0}%".format([str(colony.economicsStructure.minerals)])
	get_node("ColonyStatsContainer/Col1/FuelEconomics/Label").text="{0}%".format([str(colony.economicsStructure.fuel)])
	get_node("ColonyStatsContainer/Col1/MaterialsEconomics/Label").text="{0}%".format([str(colony.economicsStructure.processedMaterials)])
	
	get_node("ColonyStatsContainer/Col1/FoodProduction/Label").text=str(colony.producedLastTick.food)
	get_node("ColonyStatsContainer/Col1/MineralsProduction/Label").text=str(colony.producedLastTick.minerals)
	get_node("ColonyStatsContainer/Col1/FuelProduction/Label").text=str(colony.producedLastTick.fuel)
	get_node("ColonyStatsContainer/Col1/MaterialsProduction/Label").text=str(colony.producedLastTick.processedMaterials)
	
	get_node("ColonyStatsContainer/Col1/FoodConsuption/Label").text=str(colony.consumedLastTick.food)
	get_node("ColonyStatsContainer/Col1/MineralsConsumption/Label").text=str(colony.consumedLastTick.minerals)
	get_node("ColonyStatsContainer/Col1/FuelConsumption/Label").text=str(colony.consumedLastTick.fuel)
	get_node("ColonyStatsContainer/Col1/MaterialsConsumption/Label").text=str(colony.consumedLastTick.processedMaterials)
	
	get_node("ColonyStatsContainer/Col1/FoodStorage/Label").text=str(colony.storage.food)
	get_node("ColonyStatsContainer/Col1/MineralsStorage/Label").text=str(colony.storage.minerals)
	get_node("ColonyStatsContainer/Col1/FuelStorage/Label").text=str(colony.storage.fuel)
	get_node("ColonyStatsContainer/Col1/MaterialsStorage/Label").text=str(colony.storage.processedMaterials)
	
	get_node("ColonyStatsContainer/Col2/FoodImport/Label").text=str(colony.importedLastTick.food)
	get_node("ColonyStatsContainer/Col2/MineralsImport/Label").text=str(colony.importedLastTick.minerals)
	get_node("ColonyStatsContainer/Col2/FuelImport/Label").text=str(colony.importedLastTick.fuel)
	get_node("ColonyStatsContainer/Col2/MetalsImport/Label").text=str(colony.importedLastTick.processedMaterials)
	
	get_node("ColonyStatsContainer/Col2/FoodExport/Label").text=str(colony.exportedLastTick.food)
	get_node("ColonyStatsContainer/Col2/MineralsExport/Label").text=str(colony.exportedLastTick.minerals)
	get_node("ColonyStatsContainer/Col2/FuelExport/Label").text=str(colony.exportedLastTick.fuel)
	get_node("ColonyStatsContainer/Col2/MetalsExport/Label").text=str(colony.exportedLastTick.processedMaterials)
	
	
func _on_selected_planet(pl:SimulationPlanet)->void:
	selectedPlanet=pl
	


func _on_texture_button_pressed() -> void:
	self.queue_free()
