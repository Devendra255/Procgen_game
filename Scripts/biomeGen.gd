class_name BiomeGen

var height : int
var width : int
var alt := {}
var ppt := {}
var tem := {}
var alt_noise = FastNoiseLite.new()
var ppt_noise = FastNoiseLite.new()
var tem_noise = FastNoiseLite.new()

func _init(height:int,width:int):
	self.height = height
	self.width = width
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
	
func value_from_noise(noise: FastNoiseLite)->Dictionary: 
	var gridValue = {}
	for x in width+1:
		for y in height+1:
			var value = noise.get_noise_2d(x,y)
			gridValue[Vector2(x,y)] = value
	return gridValue 
