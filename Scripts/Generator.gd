extends Node2D
var thread : Thread
var biom = BiomeGen.new(200,200)

func gen_biomes():
	biom.alt = biom.value_from_noise(biom.alt_noise)
	biom.ppt = biom.value_from_noise(biom.ppt_noise)
	biom.tem = biom.value_from_noise(biom.tem_noise)
	print(biom.alt)
	print(biom.ppt)
	print(biom.tem)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	thread.start(gen_biomes)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _exit_tree():
	thread.wait_to_finish()
