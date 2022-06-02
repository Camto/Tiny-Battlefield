extends Node2D

const Unit_Card_Data = preload("res://Scripts/Unit_Card_Data.gd")
const Building_Card_Data = preload("res://Scripts/Building_Card_Data.gd")
const Event_Card_Data = preload("res://Scripts/Event_Card_Data.gd")

onready var hand_sprite_name = $Name
onready var hand_sprite_cost = $Cost
onready var hand_sprite_text = $Text
onready var hand_sprite_art = $Art
onready var hand_sprite_power = $Power

var card_data

func set_card_data(card_data):
	self.card_data = card_data
	
	hand_sprite_name.text = card_data.card_name
	hand_sprite_cost.text = str(card_data.cost)
	hand_sprite_text.text = card_data.text
	hand_sprite_art.texture = card_data.art
	if card_data is Unit_Card_Data:
		hand_sprite_power.text = str(card_data.power)