extends Node2D

signal hover(tile)
signal unhover(tile)

const tile_size = 650/3

var pos = Vector2.ZERO

var card

func set_pos(pos):
	self.pos = pos
	position = Vector2((pos.x - 1) * tile_size, (pos.y - 1) * tile_size)

func set_card(card):
	add_child(card)
	card.set_owner(self)
	self.card = card

func _on_Area2D_mouse_entered():
	emit_signal("hover", self)

func _on_Area2D_mouse_exited():
	emit_signal("unhover", self)