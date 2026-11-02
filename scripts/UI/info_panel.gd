extends Control

var currentTick=0
var currentEmpire:SimulationEmpire
var selectedStar:SimulationStar
signal openStar(star:SimulationStar)

func _process(delta: float) -> void:
	get_node("Panel/CurrentTick").text="Текущий тик {tick}".format({'tick':currentTick})
	var empireLabel=get_node("Panel/EmpireHeader/Label")
	empireLabel.label_settings.font_color=currentEmpire.color
	empireLabel.text="Империя: {empire}".format({'empire':currentEmpire.name})
	getEmpireStats()
	if(selectedStar!=null):
		get_node("Panel/SelectedStar").visible=true
		getSelectedStarStats()
	else:
		get_node("Panel/SelectedStar").visible=false


func getEmpireStats()->void:
	get_node("Panel/EmpireColonyNumber/Label").text=str(currentEmpire.colonies.size())
	var pop=0
	var food=0
	var minerals=0
	var fuel=0
	var processedMaterials=0
	for colony in currentEmpire.colonies:
		pop+=colony.population
		food+=colony.storage.food
		minerals+=colony.storage.minerals
		fuel+=colony.storage.fuel
		processedMaterials+=colony.storage.processedMaterials
		
	get_node("Panel/TotalFood/Label").text=str(food)
	get_node("Panel/TotalFuel/Label").text=str(fuel)
	get_node("Panel/TotalMinerals/Label").text=str(minerals)
	get_node("Panel/TotalPopulation/Label").text=str(pop)
	get_node("Panel/TotalProcessedMetals/Label").text=str(processedMaterials)


func getSelectedStarStats() -> void:
	var pop=0
	var storage=PlanetaryResourcesDto.new().fill(0,0,0,0)
	var produced=PlanetaryResourcesDto.new().fill(0,0,0,0)
	var consumed=PlanetaryResourcesDto.new().fill(0,0,0,0)
	var colonizedCount=0
	for planet in selectedStar.planets:
		if(planet.colony==null):
			continue
		var colony=planet.colony
		colonizedCount+=1
		pop+=colony.population
		storage.add(colony.storage)
		produced.add(colony.producedLastTick)
		consumed.add(colony.consumedLastTick)
	get_node("Panel/SelectedStar/StarNameHeader").text="Звезда: {star_name}".format({'star_name':selectedStar.name})
	get_node("Panel/SelectedStar/ColonizedNumber").text="Колонизированных планет: {num}".format({'num':colonizedCount})
	get_node("Panel/SelectedStar/TotalFood/Label").text="{0} +{1} -{2}".format([str(storage.food),str(produced.food),str(consumed.food)])
	get_node("Panel/SelectedStar/TotalFuel/Label").text="{0} +{1} -{2}".format([str(storage.fuel),str(produced.fuel),str(consumed.fuel)])
	get_node("Panel/SelectedStar/TotalMinerals/Label").text="{0} +{1} -{2}".format([str(storage.minerals),str(produced.minerals),str(consumed.minerals)])
	get_node("Panel/SelectedStar/TotalPopulation/Label").text=str(pop)
	get_node("Panel/SelectedStar/TotalProcessedMetals/Label").text="{0} +{1} -{2}".format([str(storage.processedMaterials),str(produced.processedMaterials),str(consumed.processedMaterials)])

	


func _on_texture_button_pressed() -> void:
	openStar.emit(selectedStar)
