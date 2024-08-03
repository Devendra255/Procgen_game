extends Node2D
var biome : BiomeGen
var height := 40
var width := 61
var world_seed : int
var player_tile_pos
@onready var tile_map = $TileMap
@export var player: CharacterBody2D 

var tiles := {
	"sea":[0, 0, [Vector2i(27, 5)]],
	"sand": [0, 0, [Vector2i(19, 9)]],
	"land":[0, 0, [Vector2i(1, 9),Vector2i(0, 11), Vector2i(1, 11), Vector2i(2, 11), Vector2i(4, 11)]]
}
var biome_info := {
	"sea": [[-2, 0.04], [-2, 2], [-2, 2]],
	"sand": [[0.04, 0.1], [-2, 2], [-2, 2]],
	"land": [[0.1, 2], [-2, 2], [-2, 2]]
}

func Generating()-> void:
	world_seed = randi()
	biome = BiomeGen.new(self.height*4, self.width*4, world_seed)
	biome.set_biomes(biome_info, tile_map.local_to_map(player.position))
	biome.render_tiles(tiles, tile_map, tile_map.local_to_map(player.position))
	biome.height = self.height
	biome.width = self.width

# Called when the node enters the scene tree for the first time.
func _ready():
	Generating()
	
func threading():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_tile_pos != tile_map.local_to_map(player.position):
		player_tile_pos = tile_map.local_to_map(player.position)
		biome.set_biomes(biome_info, player_tile_pos)
		biome.render_tiles(tiles, tile_map, player_tile_pos)
		biome.unload_distant_chunks(player_tile_pos, tile_map)

