extends Node2D
var thread : Thread
var thread1 : Thread
var thread2 : Thread
var biome : BiomeGen
var height := 200
var width := 200
#var tile := {
	#"tileName":{
		#"layer": 0, 
		#"source_id": -1, 
		#"atlas_coords": Vector2i(-1, -1)
	#}
#}
var biome_info := {
	"sea":{
		"alt": [-1, 0.01],
		"ppt": [-1, 1],
		"tem": [-1, 1]
	},
	"land":{
		"alt": [0.01, 1],
		"ppt": [-1, 1],
		"tem": [-1, 1]
	}
}

func threading()-> void:
	thread1 = Thread.new()
	thread2 = Thread.new()
	thread1.start(func(): biome = BiomeGen.new(self.height, self.width))
	thread1.wait_to_finish()
	thread2.start(biome.set_biomes.bind(biome_info))

# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	thread.start(threading)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _exit_tree():
	thread.wait_to_finish()
	thread1.wait_to_finish()
	thread2.wait_to_finish()
