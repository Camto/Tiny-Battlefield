extends Node2D

signal hover(card)
signal drop(card)

const width = 230
const gap_in_hand = -40
const dist_in_hand = width + gap_in_hand

var highlighted = false
var dragging

onready var home = position
onready var up = home - Vector2(0, 100)

func _process(delta):
	if dragging:
		position = get_parent().to_local(get_viewport().get_mouse_position())
	elif highlighted:
		position = up
	else:
		position = home

func set_pos(idx, total):
	home.x = (idx - float(total - 1) / 2) * dist_in_hand
	up = home - Vector2(0, 100)

func _on_Area2D_mouse_entered():
	if !dragging && !highlighted:
		highlighted = true
		z_index = 10
		emit_signal("hover", self)

func _on_Area2D_mouse_exited():
	if !dragging && highlighted:
		highlighted = false
		z_index = 0

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if event.pressed:
			dragging = true
		else:
			dragging = false
			emit_signal("drop", self)