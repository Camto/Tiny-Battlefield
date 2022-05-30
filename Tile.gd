extends Node2D

signal hover(tile)
signal unhover(tile)

const tile_size = 650/3

var pos = Vector2.ZERO

func set_pos(pos):
	self.pos = pos
	position = Vector2((pos.x - 1) * tile_size, (pos.y - 1) * tile_size)

func _on_Area2D_mouse_entered():
	emit_signal("hover", self)

func _on_Area2D_mouse_exited():
	emit_signal("unhover", self)