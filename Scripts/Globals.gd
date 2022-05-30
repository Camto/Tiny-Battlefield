extends Node

const Unit_Card_Data = preload("res://Scripts/Unit_Card_Data.gd")
const Building_Card_Data = preload("res://Scripts/Building_Card_Data.gd")
const Event_Card_Data = preload("res://Scripts/Event_Card_Data.gd")

enum Player {player, opponent}

var turn_of = Player.player

var player_actions = 0
var player_gold = 2

var can_play = true

var opponent_actions = 0
var opponent_gold = 0

var openable_cards = []

func get_actions():
	if turn_of == Player.player:
		return player_actions
	else:
		return opponent_actions

func get_gold():
	if turn_of == Player.player:
		return player_gold
	else:
		return opponent_gold

func gain_actions(actions):
	if turn_of == Player.player:
		player_actions += actions
	else:
		opponent_actions += actions

func gain_gold(gold):
	if turn_of == Player.player:
		player_gold += gold
	else:
		opponent_gold += gold

func spend_actions(actions):
	if turn_of == Player.player:
		player_actions -= actions
	else:
		opponent_actions -= actions

func spend_gold(gold):
	if turn_of == Player.player:
		player_gold -= gold
	else:
		opponent_gold -= gold

func _ready():
	randomize()
	
	var card
	
	card = Unit_Card_Data.new()
	card.card_name = "Soldier"
	card.cost = 1
	card.text = ""
	card.power = 1
	card.effects = {}
	openable_cards.append(card)