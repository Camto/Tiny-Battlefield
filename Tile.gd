extends Node2D

signal hover(tile)
signal unhover(tile)

const tile_size = 650/3

var x = 0
var y = 0

func set_pos(x, y):
	self.x = x
	self.y = y
	position = Vector2((x - 1) * tile_size, (y - 1) * tile_size)

func _on_Area2D_mouse_entered():
	emit_signal("hover", self)

func _on_Area2D_mouse_exited():
	emit_signal("unhover", self)