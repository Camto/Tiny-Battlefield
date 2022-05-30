extends Node2D

signal hover(object)
signal unhover(object)

const Tile = preload("res://Tile.tscn")

func _ready():
	for y in range(3):
		for x in range(3):
			var tile = Tile.instance()
			tile.set_pos(x, y)
			tile.connect("hover", self, "_on_Tile_hover")
			tile.connect("unhover", self, "_on_Tile_unhover")
			add_child(tile)

func _on_Tile_hover(tile):
	emit_signal("hover", tile)
	
func _on_Tile_unhover(tile):
	emit_signal("unhover", tile)