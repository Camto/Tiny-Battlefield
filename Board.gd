extends Node2D

signal hover(zone)
signal unhover(zone)

const Tile = preload("res://Tile.tscn")

func _ready():
	for y in range(3):
		for x in range(3):
			var tile = Tile.instance()
			tile.set_pos(Vector2(x, y))
			tile.connect("hover", self, "_on_Tile_hover")
			tile.connect("unhover", self, "_on_Tile_unhover")
			add_child(tile)

func play(card, zone):
	zone.set_card(card)

func _on_Tile_hover(tile):
	emit_signal("hover", tile)
	
func _on_Tile_unhover(tile):
	emit_signal("unhover", tile)