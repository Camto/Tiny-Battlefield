extends Node2D

var board_parts_hovered = []

func _on_Board_hover(object):
	if !board_parts_hovered.has(object):
		board_parts_hovered.append(object)

func _on_Board_unhover(object):
	board_parts_hovered.erase(object)

func _on_Hand_drop(card):
	if board_parts_hovered.size() > 0:
		var part = board_parts_hovered[0]
		part.visible = false