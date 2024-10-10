extends Node2D
var biome: BiomeGen
var height := 41
var width := 73
var world_seed: int
var player_tile_pos
@onready var tile_map = $TileMapLayer
@export var player: CharacterBody2D
@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var label: Label = $CanvasLayer/Control/MarginContainer/Label

var tiles := {
	"sea": [0, [Vector2i(27, 5)]],
	"beach": [0, [Vector2i(19, 9)]],
	"Grasslands": [0, [Vector2i(1, 9), Vector2i(0, 11), Vector2i(1, 11), Vector2i(2, 11), Vector2i(4, 11)]],
	"forest": [0, [Vector2i(7, 9), Vector2i(6, 11), Vector2i(7, 11), Vector2i(8, 11)]],
	"desert": [0, [Vector2i(19, 9), Vector2i(18, 11), Vector2i(19, 11), Vector2i(20, 11)]],
	"snow": [0, [Vector2i(19, 15), Vector2i(18, 17), Vector2i(19, 17), Vector2i(20, 17)]],
	"river": [0, [Vector2i(28, 5)]],
}
var biome_info := { # -2 or 2 is like negative or positive infinaty
	"sea": [[-2, 0.04], [-2, 2], [-2, 2]],
	"beach": [[0.04, 0.1], [-2, 2], [-2, 2]],
	"Grasslands": [[0.1, 2], [-2, 2], [-2, 2]],
	"forest": [[0.13, 2], [0.66, 2], [-0.2, 0.5]],
	"desert": [[0.1, 0.5], [-2, 0.3], [-0.1, 0.9]],
	"snow": [[0.4, 2], [-2, 2], [-2, 0.2]],
}

func Generating() -> void:
	world_seed = GlobalPara.get_seed() #1941095856
	biome = BiomeGen.Biome2D.new(self.height * 2, self.width * 2, world_seed)
	biome.create_rivers(tile_map.local_to_map(player.position))
	biome.set_biomes(biome_info, tile_map.local_to_map(player.position))
	biome.render_tiles(tiles, tile_map, tile_map.local_to_map(player.position))
	biome.height = self.height
	biome.width = self.width

# Called when the node enters the scene tree for the first time.
func _ready():
	Generating()
	player_tile_pos = tile_map.local_to_map(player.position)
	label.text = str(player_tile_pos)


func cam_zoom():
	var up = Input.get_action_strength("Q")
	var down = -(Input.get_action_strength("E"))
	if camera_2d.zoom.x >= 0.08 or up == 1:
		camera_2d.zoom.x += (up + down) * 0.05
		camera_2d.zoom.y += (up + down) * 0.05
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam_zoom()
	if player_tile_pos != tile_map.local_to_map(player.position):
		label.text = str(player_tile_pos)
		biome.create_rivers(player_tile_pos)
		biome.set_biomes(biome_info, player_tile_pos)
		biome.render_tiles(tiles, tile_map, player_tile_pos)
		biome.unload_distant_chunks(player_tile_pos, tile_map)

	player_tile_pos = tile_map.local_to_map(player.position)
