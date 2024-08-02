extends Node2D
var thread : Thread
var biom : BiomeGen
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
func gen_biomes():
	biom = BiomeGen.new(200,200)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	thread.start(gen_biomes)
	if thread.is_alive():
		thread.wait_to_finish()
		biom.set_biomes(biome_info)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _exit_tree():
	thread.wait_to_finish()
