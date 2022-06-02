extends Node2D

signal hover(zone)
signal unhover(zone)

signal card_hover(card)
signal card_drop(card)
signal card_move(card, zone)
signal card_attack(card, target)
signal card_die(card)

const Tile = preload("res://Scenes/Tile.tscn")
const Tile_Class = preload("res://Scripts/Tile.gd")

var tiles = {}

func _ready():
	for y in range(3):
		for x in range(3):
			var tile = Tile.instance()
			var pos = Vector2(x, y)
			tile.set_pos(pos)
			tile.connect("hover", self, "_on_Tile_hover")
			tile.connect("unhover", self, "_on_Tile_unhover")
			add_child(tile)
			tiles[pos] = tile

func play(card, zone):
	card.connect("hover", self, "_on_Card_hover")
	card.connect("drop", self, "_on_Card_drop")
	card.connect("move", self, "_on_Card_move")
	card.connect("attack", self, "_on_Card_attack")
	card.connect("die", self, "_on_Card_die")
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
	emit_signal("card_move", card, zone)

func _on_Card_attack(card, target):
	print("attacked")
	target.state.damage += 1
	target.check_for_death()
	emit_signal("card_attack", card, target)

func _on_Card_die(card):
	print("dead")
	card.get_parent().unset_card()
	emit_signal("card_die", card)