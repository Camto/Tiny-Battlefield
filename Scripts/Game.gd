extends Node2D

const Card = preload("res://Scenes/Card.tscn")

onready var board = $Board
onready var hand = $Hand
onready var discard = $Discard
onready var card_preview = $Card_Preview

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

func _on_Board_card_attack(card, target):
	did_action()

func _on_Board_card_die(card):
	discard.add_child(card)
	card.set_owner(discard)

func _on_Hand_drop(card):
	if zones_hovered.size() > 0:
		var zone = zones_hovered[0]
		card.attempt_to_play_on(zone)

func _on_Hand_play(card, zone):
	board.play(card, zone)
	did_action()

func _on_Gold_Button_pressed():
	if Globals.turn_of == Globals.Player.player && Globals.can_play && Globals.get_actions() > 0:
		Globals.gain_gold(1)
		did_action()

func _on_Draw_Button_pressed():
	if Globals.turn_of == Globals.Player.player && Globals.can_play && Globals.get_actions() > 0:
		hand.draw()
		did_action()

func _on_Pass_Button_pressed():
	if Globals.turn_of == Globals.Player.player && Globals.can_play && Globals.get_actions() > 0:
		Globals.spend_actions(Globals.get_actions())
		Globals.pass_turn()

func did_action():
	Globals.spend_actions(1)
	if Globals.get_actions() == 0:
		Globals.pass_turn()
		if Globals.turn_of == Globals.Player.opponent:
			ai_turn()

func _on_Hand_hover(card):
	preview(card)

func _on_Board_card_hover(card):
	preview(card)

func preview(card):
	card_preview.visible = true
	card_preview.set_card_data(card.card_data)



onready var opponent_deck = [
	Globals.openable_cards[0],
	Globals.openable_cards[0],
	Globals.openable_cards[0],
	Globals.openable_cards[0]
]

var playing_priorities = [
	Vector2(1, 0),
	Vector2(0, 0),
	Vector2(2, 0),
	Vector2(1, 1)
]

var opponent_units = 0

func ai_turn():
	if opponent_units == 0:
		if opponent_deck.size() > 0:
			var card = Card.instance()
			
			for idx in range(playing_priorities.size()):
				var zone = board.tiles[playing_priorities[idx]]
				if zone.card == null:
					board.play(card, zone)
					break
			
			card.set_player(Globals.Player.opponent)
			card.set_card_data(opponent_deck.pop_back())
			card.enter_play()
		else:
			print("YOU WIN!!!!!")
	
	Globals.pass_turn()