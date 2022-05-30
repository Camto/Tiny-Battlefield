extends Node2D

onready var Globals = get_node("/root/Globals")

signal hover(card)
signal drop(card)
signal play(card, zone)

const Card = preload("res://Card.tscn")

func _ready():
	for i in range(4):
		add_card()

func add_card():
	var card = Card.instance()
	card.player = Globals.Player.player
	card.card_data = Globals.openable_cards[0]
	card.connect("hover", self, "_on_Card_hover")
	card.connect("drop", self, "_on_Card_drop")
	card.connect("play", self, "_on_Card_play")
	add_child(card)
	reposition_cards()

func reposition_cards():
	var cards = get_children()
	var num_cards = cards.size()
	for idx in range(num_cards):
		cards[idx].set_hand_pos(idx, num_cards)

func _on_Card_hover(card):
	emit_signal("hover", card)
	
func _on_Card_drop(card):
	emit_signal("drop", card)

func _on_Card_play(card, zone):
	card.disconnect("hover", self, "_on_Card_hover")
	card.disconnect("drop", self, "_on_Card_drop")
	card.disconnect("play", self, "_on_Card_play")
	remove_child(card)
	reposition_cards()
	emit_signal("play", card, zone)