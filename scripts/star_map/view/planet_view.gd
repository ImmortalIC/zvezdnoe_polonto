extends Node2D
class_name PlanetView

var simulationObject:SimulationPlanet

@export var colonizedIcon:Texture2D
@export var emptyIcon:Texture2D

signal selectPlanet(selectedPlane:SimulationPlanet)


func _draw() -> void:
	var label=get_node("Label")
	var colonyState=get_node("ColonizedIndication")
	label.text=simulationObject.name
	if(label.label_settings==null):
		label.label_settings=LabelSettings.new()
		
	if(simulationObject.colony!=null):
		label.label_settings.font_color=simulationObject.colony.claimingEmpire.color
		colonyState.texture=colonizedIcon
	else:
		colonyState.texture=emptyIcon
		label.label_settings.font_color=Color(255,255,255,255)


	
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event.is_pressed()):
		selectPlanet.emit(simulationObject)
