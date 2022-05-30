extends Node2D

signal hover(zone)
signal unhover(zone)

signal card_hover(card)
signal card_drop(card)
signal card_move(card, zone)

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
	card.connect("hover", self, "_on_Card_hover")
	card.connect("drop", self, "_on_Card_drop")
	card.connect("move", self, "_on_Card_move")
	zone.set_card(card)

func _on_Tile_hover(tile):
	emit_signal("hover", tile)
	
func _on_Tile_unhover(tile):
	emit_signal("unhover", tile)

func _on_Card_hover(card):
	emit_signal("card_hover", card)

func _on_Card_drop(card):
	emit_signal("card_drop", card)

func _on_Card_move(card, zone):
	card.get_parent().unset_card()
	zone.set_card(card)