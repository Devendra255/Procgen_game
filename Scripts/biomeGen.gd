class_name BiomeGen

var height: int
var width: int
var biomes := {}
var water := {}
var alt_noise := FastNoiseLite.new()
var ppt_noise := FastNoiseLite.new()
var tem_noise := FastNoiseLite.new()
var river_points := FastNoiseLite.new()

func _init(init_height: int, init_width: int, world_seed: int):
	self.height = init_height
	self.width = init_width
	self.pre_noiseSetup(world_seed)

func pre_noiseSetup(world_seed: int) -> void:
	self.alt_noise.seed = world_seed
	self.ppt_noise.seed = world_seed
	self.tem_noise.seed = world_seed
	self.river_points.seed = world_seed
	self.river_points.noise_type = FastNoiseLite.TYPE_CELLULAR
	self.river_points.frequency = 0.15
	self.river_points.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	self.river_points.fractal_octaves = 5
	self.river_points.fractal_lacunarity = 15.0
	self.river_points.fractal_gain = -0.110
	self.river_points.fractal_weighted_strength = 7.32
	self.river_points.cellular_distance_function = FastNoiseLite.CellularDistanceFunction.DISTANCE_EUCLIDEAN_SQUARED
	self.river_points.cellular_return_type = FastNoiseLite.CellularReturnType.RETURN_DISTANCE2_MUL
	self.river_points.cellular_jitter = 0.9
	self.alt_noise.frequency = 0.01
	self.alt_noise.fractal_octaves = 5
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

func get_altitude(pos: Vector2i) -> float:
	return self.alt_noise.get_noise_2d(pos.x, pos.y)

func get_precipition(pos: Vector2i) -> float:
	return self.ppt_noise.get_noise_2d(pos.x, pos.y)

func get_temprature(pos: Vector2i) -> float:
	return self.tem_noise.get_noise_2d(pos.x, pos.y)

func get_biomes(pos: Vector2i) -> String:
	return self.biomes[pos][0]

func get_river_points_value(pos: Vector2i) -> float:
	return self.river_points.get_noise_2d(pos.x, pos.y)

class Biome2D extends BiomeGen:

	var first_time := true
	var value_jump := 1
	var search_value := 3

	func between(val, start, end) -> bool:
		if start <= val and val < end:
			return true
		return false

	func set_biomes(biome_info: Dictionary, player_pos: Vector2i = Vector2i(0, 0)) -> void:
		for x in self.width:
			var y = 0
			while y < self.height:
				var pos : Vector2i
				if !first_time:
					if (x > search_value-1 and x < width - search_value) and (y > search_value-1 and y < height - search_value):
						value_jump = height - search_value * 2 
					else:
						value_jump = 1
						pos = Vector2i(player_pos.x - floor(width as float / 2) + x, player_pos.y - floor(height as float / 2) + y)
				else:
					pos = Vector2i(player_pos.x - floor(width as float / 2) + x, player_pos.y - floor(height as float / 2) + y)
				var altitude: float = get_altitude(pos)
				var precipition: float = get_precipition(pos)
				var temprature: float = get_temprature(pos)
				var biome
				if not (self.biomes.has(pos) or self.water.has(pos)):
					for key in biome_info.keys():
						if (between(altitude, biome_info[key][0][0], biome_info[key][0][1]) and
							between(precipition, biome_info[key][1][0], biome_info[key][1][1]) and
							between(temprature, biome_info[key][2][0], biome_info[key][2][1])):
								biome = key
					self.biomes[pos] = [biome, Vector2i(-1, -1)]
				if self.water.has(pos):
					self.biomes[pos] = ["River", Vector2i(-1, -1)]
				y += value_jump
		# first_time = false

	func render_tiles(tiles: Dictionary, tilemap: TileMapLayer, player_pos: Vector2i) -> void:
		for x in self.width:
			var y = 0
			while y < self.height:
				var pos : Vector2i
				if !first_time:
					if (x > search_value-1 and x < width - search_value) and (y > search_value-1 and y < height - search_value):
						value_jump = height - search_value * 2 
					else:
						value_jump = 1
						pos = Vector2i(player_pos.x - floor(width as float / 2) + x, player_pos.y - floor(height as float / 2) + y)
				else:
					pos = Vector2i(player_pos.x - floor(width as float / 2) + x, player_pos.y - floor(height as float / 2) + y)
				var biome = self.biomes[pos][0]
				var temp = self.biomes[pos][1]
				if temp == Vector2i(-1, -1):
					temp = tiles[biome][1].pick_random()
					self.biomes[pos][1] = temp
				tilemap.set_cell(pos, tiles[biome][0], temp)
				y += value_jump
		first_time = false
				
	func unload_distant_chunks(player_pos, tilemap: TileMapLayer) -> void:
		var unload_distance_threshold := (width * 2) + 1
		for chunk in self.biomes:
			var distance_to_player = get_dist(chunk, player_pos)
			if distance_to_player > unload_distance_threshold:
				clear_chunk(chunk, tilemap)
				self.biomes.erase(chunk)

	func get_dist(p1, p2) -> float:
		var resultant = p1 - p2
		return sqrt(resultant.x ** 2 + resultant.y ** 2)
		
	func clear_chunk(pos, tilemap: TileMapLayer) -> void:
		for x in self.width:
			for y in self.height:
				# tilemap.set_cell(Vector2i(pos.x - floor(width as float / 2) + x, pos.y - floor(height as float / 2) + y), -1, Vector2i(-1, -1), -1)
				tilemap.erase_cell(Vector2i(pos.x - floor(width as float / 2) + x, pos.y - floor(height as float / 2) + y))

	func create_rivers(player_pos: Vector2i = Vector2i(0, 0)) -> void:
		for x in self.width + 5:
			for y in self.height + 5:
				var pos := Vector2i(player_pos.x - floor(width as float / 2) + x, player_pos.y - floor(height as float / 2) + y)
				var water_point := [self.get_river_points_value(pos), self.get_altitude(pos)]
				var itr_points : Array[Vector2i]
				if not self.water.has(pos):
					if water_point[0] >= -0.6 and water_point[1] > 0.3:
						itr_points.append(pos)
						while itr_points.size() > 0:
							var itr_point = itr_points.pop_front()
							self.water[itr_point] = "River"
							var water_level = self.get_altitude(itr_point)
							var neighbors = get_neighbors(itr_point)
							for neighbor in neighbors:
								if not self.water.has(neighbor):
									var altitude = self.get_altitude(neighbor)
									if altitude < water_level and altitude > 0:
										self.water[neighbor] = "River"
										itr_points.append(neighbor)
									if itr_points.size() > 4:
										break

func get_neighbors(pos: Vector2i) -> Array:
	var neighbors := []
	for x in range(-1, 2):
		for y in range(-1, 2):
			if (x == 0 and y == 0):
				continue
			neighbors.append(Vector2i(pos.x + x, pos.y + y))
	return neighbors
