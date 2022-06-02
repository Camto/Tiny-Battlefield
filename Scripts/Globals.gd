extends Node

const Unit_Card_Data = preload("res://Scripts/Unit_Card_Data.gd")
const Building_Card_Data = preload("res://Scripts/Building_Card_Data.gd")
const Event_Card_Data = preload("res://Scripts/Event_Card_Data.gd")

onready var player_action_label = $"../Game/Player_Resources/A_Label"
onready var player_gold_label = $"../Game/Player_Resources/G_Label"

onready var opponent_action_label = $"../Game/Opponent_Resources/A_Label"
onready var opponent_gold_label = $"../Game/Opponent_Resources/G_Label"

enum Player {player, opponent}

var turn_of = Player.player

var player_actions = 2
var player_gold = 2

var can_play = true

var opponent_actions = 0
var opponent_gold = 0

var dragging = false

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
	update_actions_visual(Player.player)

func gain_gold(gold):
	if turn_of == Player.player:
		player_gold += gold
	else:
		opponent_gold += gold
	update_gold_visual(Player.player)

func spend_actions(actions):
	if turn_of == Player.player:
		player_actions -= actions
	else:
		opponent_actions -= actions
	update_actions_visual(Player.player)

func spend_gold(gold):
	if turn_of == Player.player:
		player_gold -= gold
	else:
		opponent_gold -= gold
	update_gold_visual(Player.player)

func update_actions_visual(player):
	if player == Player.player:
		player_action_label.text = "A: " + str(player_actions)
	else:
		opponent_action_label.text = "A: " + str(opponent_actions)

func update_gold_visual(player):
	if player == Player.player:
		player_gold_label.text = "G: " + str(player_gold)
	else:
		opponent_gold_label.text = "G: " + str(opponent_gold)

func pass_turn():
	if turn_of == Player.player:
		turn_of = Player.opponent
	else:
		turn_of = Player.player
	gain_actions(1)

func _ready():
	update_actions_visual(Player.player)
	update_gold_visual(Player.player)
	
	update_actions_visual(Player.opponent)
	update_gold_visual(Player.opponent)
	
	randomize()
	
	var card
	
	card = Unit_Card_Data.new()
	card.card_name = "Soldier"
	card.cost = 1
	card.text = ""
	card.power = 1
	card.effects = {}
	openable_cards.append(card)