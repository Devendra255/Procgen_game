class_name BiomeGen

var height : int
var width : int
var biomes := {}
var alt_noise := FastNoiseLite.new()
var ppt_noise := FastNoiseLite.new()
var tem_noise := FastNoiseLite.new()

func _init(height: int, width: int, world_seed: int):
	self.height = height
	self.width = width
	self.pre_noiseSetup(world_seed)

func pre_noiseSetup(world_seed: int)-> void:
	self.alt_noise.seed = world_seed
	self.ppt_noise.seed = world_seed
	self.tem_noise.seed = world_seed
	self.alt_noise.frequency = 0.01
	self.ppt_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	self.ppt_noise.frequency = 0.01
	self.ppt_noise.fractal_octaves = 3
	self.ppt_noise.fractal_lacunarity = 3.0
	self.ppt_noise.fractal_gain = 0.16
	self.ppt_noise.fractal_weighted_strength = 0.92
	self.tem_noise.frequency = 0.005
	self.tem_noise.fractal_lacunarity = 3.23
	self.tem_noise.fractal_gain = 0.17
	self.tem_noise.fractal_weighted_strength = -0.52

func between(val, start, end)-> bool:
	if start <= val and val < end:
		return true
	return false

func set_biomes(biome_info: Dictionary, player_pos: Vector2i = Vector2i(0,0))-> void:
	for x in self.width:
		for y in self.height:
			var pos := Vector2i(player_pos.x - (width/2) + x, player_pos.y - (height/2) + y)
			var altitude: float = self.alt_noise.get_noise_2d(pos.x, pos.y)
			var precipition: float = self.ppt_noise.get_noise_2d(pos.x, pos.y)
			var temprature: float = self.tem_noise.get_noise_2d(pos.x, pos.y)
			var biome
			for key in biome_info.keys():
				if (between(altitude, biome_info[key][0][0], biome_info[key][0][1]) and 
					between(precipition, biome_info[key][1][0], biome_info[key][1][1]) and 
					between(temprature, biome_info[key][2][0], biome_info[key][2][1])):
						biome = key
			if not self.biomes.has(pos):
				self.biomes[pos] = [biome, Vector2i(-1,-1)]

func render_tiles(tiles: Dictionary, tilemap: TileMap, player_pos: Vector2i)-> void:
	for x in self.width:
		for y in self.height:
			var pos = Vector2i(player_pos.x - (width/2) + x, player_pos.y - (height/2) + y)
			var biome: String = biomes[Vector2i(pos)][0]
			if biomes[Vector2i(pos)][1] == Vector2i(-1,-1):
				var temp = tiles[biome][2].pick_random()
				tilemap.set_cell(tiles[biome][0], Vector2i(player_pos.x - (width/2) + x, player_pos.y - (height/2) + y), tiles[biome][1], temp)
				self.biomes[Vector2i(pos)][1] = temp
			else:
				tilemap.set_cell(tiles[biome][0], Vector2i(player_pos.x - (width/2) + x, player_pos.y - (height/2) + y), tiles[biome][1], biomes[Vector2i(pos)][1])
				
func unload_distant_chunks(player_pos, tilemap: TileMap)-> void:
	var unload_distance_threshold := (width * 4) + 1
	for chunk in biomes:
		var distance_to_player = get_dist(chunk, player_pos)
		if distance_to_player > unload_distance_threshold:
			clear_chunk(chunk, tilemap)
			biomes.erase(chunk)

func get_dist(p1, p2)-> float:
	var resultant = p1 - p2
	return sqrt(resultant.x ** 2 + resultant.y ** 2)
	
func clear_chunk(pos, tilemap: TileMap)-> void:
	for x in range(width):
		for y in range(height):
			tilemap.set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), -1, Vector2(-1, -1), -1)
