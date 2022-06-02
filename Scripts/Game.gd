extends Node2D

onready var board = $Board
onready var hand = $Hand

var zones_hovered = []

func _on_Board_hover(zone):
	if !zones_hovered.has(zone):
		zones_hovered.append(zone)

func _on_Board_unhover(zone):
	zones_hovered.erase(zone)

func _on_Board_card_drop(card):
	if zones_hovered.size() > 0:
		var zone = zones_hovered[0]
		card.attempt_to_play_on(zone)

func _on_Board_card_move(card, zone):
	did_action()

func _on_Hand_drop(card):
	if zones_hovered.size() > 0:
		var zone = zones_hovered[0]
		card.attempt_to_play_on(zone)

func _on_Hand_play(card, zone):
	board.play(card, zone)
	did_action()

func did_action():
	Globals.spend_actions(1)
	if Globals.get_actions() == 0:
		Globals.pass_turn()