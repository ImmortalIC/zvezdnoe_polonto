extends Node2D
class_name StarView

var simulationObject: SimulationStar
signal starSelected(selectedObject:SimulationStar)

func _draw() -> void:
	get_node("Label").text=simulationObject.name
	


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event.is_pressed()):
		starSelected.emit(simulationObject)
