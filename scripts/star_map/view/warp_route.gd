extends Node2D

var pointA: StarView
var pointB: StarView
var routeData: WarpRouteData

func _draw() -> void:
	var line=get_node("Line2D")
	line.points=PackedVector2Array([pointA.position,pointB.position])
