extends RefCounted
class_name SimulationStar


var name: String
var linkedRoutes: Array[WarpRoute]
var planets: Array[SimulationPlanet]

var systemExport:Array[PlanetaryTrade]
var systemDeficit:Array[PlanetaryTrade]

func processSystemTrade()->void:
	if(systemExport.size()==0 || systemDeficit.size()==0):
		return
		
	systemExport.sort_custom(func(a:PlanetaryTrade,b:PlanetaryTrade)->bool: return a.resources.food>b.resources.food)
	systemDeficit.sort_custom(func(a:PlanetaryTrade,b:PlanetaryTrade)->bool: return a.resources.food<b.resources.food)
	for importer in systemDeficit:
		for exporter in systemExport:
			if importer.resources.food==0:
				break
			if(exporter.resources.food==0):
				continue
			var num=0
			if(exporter.food>importer.resources.food):
				num=importer.resources.food
			else:
				num=exporter.resources.food
			exporter.colony.exportFood(num)
			exporter.resources.food-=num
			importer.colony.importFood(num)
			importer.resources.food-=num
			
	systemExport.sort_custom(func(a:PlanetaryTrade,b:PlanetaryTrade)->bool: return a.resources.minerals>b.resources.minerals)
	systemDeficit.sort_custom(func(a:PlanetaryTrade,b:PlanetaryTrade)->bool: return a.resources.minerals<b.resources.minerals)
	for importer in systemDeficit:
		for exporter in systemExport:
			if importer.resources.minerals==0:
				break
			if(exporter.resources.minerals==0):
				continue
			var num=0
			if(exporter.minerals>importer.resources.minerals):
				num=importer.resources.minerals
			else:
				num=exporter.resources.minerals
			exporter.colony.exportMinerals(num)
			exporter.resources.minerals-=num
			importer.colony.importMinerals(num)
			importer.resources.minerals-=num
	
	systemExport.sort_custom(func(a:PlanetaryTrade,b:PlanetaryTrade)->bool: return a.resources.fuel>b.resources.fuel)
	systemDeficit.sort_custom(func(a:PlanetaryTrade,b:PlanetaryTrade)->bool: return a.resources.fuel<b.resources.fuel)
	for importer in systemDeficit:
		for exporter in systemExport:
			if importer.resources.fuel==0:
				break
			if(exporter.resources.fuel==0):
				continue
			var num=0
			if(exporter.fuel>importer.resources.fuel):
				num=importer.resources.fuel
			else:
				num=exporter.resources.fuel
			exporter.colony.exportFuel(num)
			exporter.resources.fuel-=num
			importer.colony.importFuel(num)
			importer.resources.fuel-=num
	
	systemExport.sort_custom(func(a:PlanetaryTrade,b:PlanetaryTrade)->bool: return a.resources.processedMaterials>b.resources.processedMaterials)
	systemDeficit.sort_custom(func(a:PlanetaryTrade,b:PlanetaryTrade)->bool: return a.resources.processedMaterials<b.resources.processedMaterials)
	for importer in systemDeficit:
		for exporter in systemExport:
			if importer.resources.processedMaterials==0:
				break
			if(exporter.resources.processedMaterials==0):
				continue
			var num=0
			if(exporter.processedMaterials>importer.resources.processedMaterials):
				num=importer.resources.processedMaterials
			else:
				num=exporter.resources.processedMaterials
			exporter.colony.exportMetals(num)
			exporter.resources.processedMaterials-=num
			importer.colony.importMetals(num)
			importer.resources.processedMaterials-=num





func cleanUpTradeData()->void:
	systemExport.clear()
	systemDeficit.clear()
