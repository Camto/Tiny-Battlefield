extends Node2D

signal hover(tile)
signal unhover(tile)

const tile_size = 650/3

onready var hightlight = $Highlight

var pos = Vector2.ZERO

var card

func set_pos(pos):
	self.pos = pos
	position = Vector2((pos.x - 1) * tile_size, (pos.y - 1) * tile_size)

func unset_card():
	remove_child(card)
	card = null

func set_card(card):
	add_child(card)
	card.set_owner(self)
	self.card = card

func adjacent(tile):
	return (
		pos.x == tile.pos.x && abs(pos.y - tile.pos.y) == 1 ||
		pos.y == tile.pos.y && abs(pos.x - tile.pos.x) == 1)

func _on_Area2D_mouse_entered():
	hightlight.visible = true
	emit_signal("hover", self)

func _on_Area2D_mouse_exited():
	hightlight.visible = false
	emit_signal("unhover", self)