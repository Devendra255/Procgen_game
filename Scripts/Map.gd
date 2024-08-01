extends Node2D
@export var width  = 600
@export var height  = 400
@onready var tilemap = $TileMap
var temperature = {}
var moisture = {}
var altitude = {}
var biome = {}
var fastNoiseLite = FastNoiseLite.new() 

var tiles = {"grass": 2, "water": 4, "stone": 5}


func generate_map(freq, oct, seed):
	fastNoiseLite.seed = seed
	#fastNoiseLite.noise_type = 3
	fastNoiseLite.frequency = freq
	fastNoiseLite.fractal_octaves = oct
	var gridName = {}
	for x in width:
		for y in height:
			var rand = fastNoiseLite.get_noise_2d(x,y)
			gridName[Vector2(x,y)] = rand
	return gridName


# Called when the node enters the scene tree for the first time.
func _ready():
	temperature = generate_map(0.03, 5, randi())
	moisture = generate_map(0.01, 3, randi())
	altitude = generate_map(0.01, 7, randi())
	set_tile(width, height)

func set_tile(width, height):
	for x in width:
		for y in height:
			var pos = Vector2(x, y)
			var alt = altitude[pos]
			var temp = temperature[pos]
			var moist = moisture[pos]
			
			#Ocean
			if alt <= 0:
				biome[pos] = "water"
				tilemap.set_cell(0, pos, 2, Vector2i(13,3))
			if alt > 0 and alt < 0.1:
				biome[pos] = "beach"
				tilemap.set_cell(0, pos, 7, Vector2i(3,0))
			if alt > 0.1 and alt < 0.3:
				biome[pos] = "GrassLand"
				tilemap.set_cell(0, pos, 2, Vector2i(18,1))
			if alt > 0.3:
				biome[pos] = "Hills"
				tilemap.set_cell(0, pos, 7, Vector2i(7,0))
