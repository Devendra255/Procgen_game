class_name BiomeGen

var height : int
var width : int
var alt := {}
var ppt := {}
var tem := {}
var biomes := {}
var alt_noise := FastNoiseLite.new()
var ppt_noise := FastNoiseLite.new()
var tem_noise := FastNoiseLite.new()
var thread_alt : Thread
var thread_ppt : Thread
var thread_tem : Thread

func _init(height: int,width: int):
	self.height = height
	self.width = width
	self.pre_noiseSetup()
	self.thread_alt = Thread.new()
	self.thread_ppt = Thread.new()
	self.thread_tem = Thread.new()
	self.thread_alt.start(set_alt)
	self.thread_ppt.start(set_ppt)
	self.thread_tem.start(set_tem)
	if (self.thread_alt.is_alive() or 
		self.thread_ppt.is_alive() or 
		self.thread_tem.is_alive()):
		self.thread_alt.wait_to_finish()
		self.thread_ppt.wait_to_finish()
		self.thread_tem.wait_to_finish()
		print("Done") # Remember to remove prints 
	print("Done")

func set_alt():
	self.alt = self.value_from_noise(self.alt_noise)
func set_ppt():
	self.ppt = self.value_from_noise(self.ppt_noise)
func set_tem():
	self.tem = self.value_from_noise(self.tem_noise)

func pre_noiseSetup() -> void:
	self.ppt_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	self.ppt_noise.frequency = 0.005
	self.ppt_noise.fractal_octaves = 3
	self.ppt_noise.fractal_lacunarity = 3.0
	self.ppt_noise.fractal_gain = 0.16
	self.ppt_noise.fractal_weighted_strength = 0.92
	self.tem_noise.frequency = 0.003
	self.tem_noise.fractal_lacunarity = 3.23
	self.tem_noise.fractal_gain = 0.17
	self.tem_noise.fractal_weighted_strength = -0.52
	
func value_from_noise(noise: FastNoiseLite) -> Dictionary: 
	var gridValue := {}
	for x in self.width+1:
		for y in self.height+1:
			var value := noise.get_noise_2d(x,y)
			gridValue[Vector2(x,y)] = value
	return gridValue 

func between(val, start, end):
	if start <= val and val < end:
		return true

func set_biomes(biome_info: Dictionary, tilemap: TileMap=null, tiles: Dictionary={}):
	for x in self.width+1:
		for y in self.height+1:
			var pos := Vector2(x,y)
			var altitude: float = self.alt[pos]
			var precipition: float = self.ppt[pos]
			var temprature: float = self.tem[pos]
			for key in biome_info:
				if (between(altitude, biome_info[key]["alt"][0], biome_info[key]["alt"][1]) and 
					between(precipition, biome_info[key]['ppt'][0], biome_info[key]['ppt'][1]) and 
					between(temprature, biome_info[key]['tem'][0], biome_info[key]['tem'][1])):
					self.biomes[pos] = key
					if not tiles.is_empty():
						if tilemap != null:
							tilemap.set_cell(tiles[key]["layer"], pos,
										tiles[key]["source_id"], 
										tiles[key]["atlas_coords"])
