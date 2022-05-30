extends Node2D

signal hover(card)
signal drop(card)

const Card = preload("res://Card.tscn")

func _ready():
	for i in range(4):
		add_card()

func add_card():
	var card = Card.instance()
	card.connect("hover", self, "_on_Card_hover")
	card.connect("drop", self, "_on_Card_drop")
	add_child(card)
	reposition_cards()

func reposition_cards():
	var cards = get_children()
	var num_cards = cards.size()
	for idx in range(num_cards):
		cards[idx].set_pos(idx, num_cards)

func _on_Card_hover(card):
	emit_signal("hover", card)
	
func _on_Card_drop(card):
	emit_signal("drop", card)