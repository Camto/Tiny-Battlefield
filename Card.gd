extends Node2D

onready var Globals = get_node("/root/Globals")

signal hover(card)
signal drop(card)
signal play(card, zone)
signal move(card, zone)
signal error_playing(msg)

const Deck_Card = preload("res://Deck_Card.gd")
const Hand_Card = preload("res://Hand_Card.gd")
const Play_Card = preload("res://Play_Card.gd")
const Discard_Card = preload("res://Discard_Card.gd")

const Unit_Card_Data = preload("res://Unit_Card_Data.gd")
const Building_Card_Data = preload("res://Building_Card_Data.gd")
const Event_Card_Data = preload("res://Event_Card_Data.gd")

const Tile = preload("res://Tile.gd")

const width = 230
const gap_in_hand = -40
const dist_in_hand = width + gap_in_hand

const play_width = Tile.tile_size - 40

var highlighted = false
var dragging

onready var home = position
onready var up = home - Vector2(0, 100)

var player
var card_data
var state = Hand_Card.new()

func _process(delta):
	if dragging:
		position = get_parent().to_local(get_viewport().get_mouse_position())
	elif state is Play_Card:
		position = Vector2.ZERO
	elif highlighted:
		position = up
	else:
		position = home

func set_hand_pos(idx, total):
	home.x = (idx - float(total - 1) / 2) * dist_in_hand
	up = home - Vector2(0, 100)

func attempt_to_play_on(zone):
	if state is Hand_Card:
		if card_data is Unit_Card_Data:
			if zone is Tile:
				if zone.card == null:
					if Globals.get_gold() >= card_data.cost:
						Globals.spend_actions(1)
						Globals.spend_gold(card_data.cost)
						state = Play_Card.new()
						$Polygon2D.visible = false
						$Sprite.visible = false
						$Sprite2.visible = true
						emit_signal("play", self, zone)
					else:
						emit_signal("error_playing", "Not enough gold")
				else:
					emit_signal("error_playing", "Tile already occupied")
			else:
				emit_signal("error_playing", "Not a valid zone")
		else:
			emit_signal("error_playing", "Not a unit card")
	elif state is Play_Card:
		if card_data is Unit_Card_Data:
			if zone is Tile:
				if zone.card == null:
					if zone.adjacent(get_parent()):
						Globals.spend_actions(1)
						emit_signal("move", self, zone)
					else:
						emit_signal("error_playing", "Can only move to adjacent zone")
				elif zone.card.player != player:
					pass
				else:
					emit_signal("error_playing", "Can't attack friendly units")
			else:
				emit_signal("error_playing", "Not a valid zone to move or attack")
		else:
			emit_signal("error_playing", "Can't move or attack with building")
	else:
		emit_signal("error_playing", "Card already in play")

func _on_Area2D_mouse_entered():
	if Globals.turn_of == player && !dragging && !highlighted:
		highlighted = true
		z_index = 10
		emit_signal("hover", self)

func _on_Area2D_mouse_exited():
	if Globals.turn_of == player && !dragging && highlighted:
		highlighted = false
		z_index = 0

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if Globals.can_play && Globals.turn_of == player && event.pressed:
			dragging = true
			z_index = 20
		elif Globals.can_play && Globals.turn_of == player:
			dragging = false
			z_index = 0
			emit_signal("drop", self)