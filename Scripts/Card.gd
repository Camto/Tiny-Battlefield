extends Node2D

signal hover(card)
signal drop(card)

signal play(card, zone)
signal move(card, zone)
signal attack(card, target)

signal die(card)

signal error_playing(msg)

const Deck_Card = preload("res://Scripts/Deck_Card.gd")
const Hand_Card = preload("res://Scripts/Hand_Card.gd")
const Play_Card = preload("res://Scripts/Play_Card.gd")
const Discard_Card = preload("res://Scripts/Discard_Card.gd")

const Unit_Card_Data = preload("res://Scripts/Unit_Card_Data.gd")
const Building_Card_Data = preload("res://Scripts/Building_Card_Data.gd")
const Event_Card_Data = preload("res://Scripts/Event_Card_Data.gd")

const Tile = preload("res://Scripts/Tile.gd")

onready var hand_sprite = $Hand_Sprite
onready var play_sprite = $Play_Sprite
onready var opponent_indicator = $Opponent_Indicator

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

func set_card_data(card_data):
	self.card_data = card_data
	hand_sprite.set_card_data(card_data)

func set_player(player):
	self.player = player
	opponent_indicator.visible = player == Globals.Player.opponent

func set_hand_pos(idx, total):
	home.x = (idx - float(total - 1) / 2) * dist_in_hand
	home.y += rand_range(-10, 10)
	up = home - Vector2(0, 100)

func attempt_to_play_on(zone):
	if state is Hand_Card:
		if card_data is Unit_Card_Data:
			if zone is Tile:
				if zone.card == null:
					if Globals.get_gold() >= card_data.cost:
						Globals.spend_gold(card_data.cost)
						enter_play()
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
				var target = zone.card
				
				if target == null:
					if zone.adjacent(get_parent()):
						emit_signal("move", self, zone)
					else:
						emit_signal("error_playing", "Can only move to adjacent zone")
				elif target.player != player:
					if zone.adjacent(get_parent()):
						if state.power >= target.state.power:
							emit_signal("attack", self, target)
						else:
							emit_signal("error_playing", "Can't attack a unit with greater power")
					else:
						emit_signal("error_playing", "Can only attack adjacent zones")
				else:
					emit_signal("error_playing", "Can't attack friendly units")
			else:
				emit_signal("error_playing", "Not a valid zone to move or attack")
		else:
			emit_signal("error_playing", "Can't move or attack with building")
	else:
		emit_signal("error_playing", "Card not playable")

func enter_play():
	state = Play_Card.new()
	state.power = card_data.power
	state.effects = card_data.effects
	hand_sprite.visible = false
	play_sprite.visible = true

func check_for_death():
	if state.damage >= 2:
		state = Discard_Card.new()
		emit_signal("die", self)

func _on_Hand_Hitbox_mouse_entered():
	if state is Hand_Card:
		_on_hitbox_mouse_entered()

func _on_Play_Hitbox_mouse_entered():
	if state is Play_Card:
		_on_hitbox_mouse_entered()

func _on_hitbox_mouse_entered():
	if !dragging && !highlighted:
		highlighted = true
		z_index = 10
		emit_signal("hover", self)

func _on_Hand_Hitbox_mouse_exited():
	if state is Hand_Card:
		_on_hitbox_mouse_exited()

func _on_Play_Hitbox_mouse_exited():
	if state is Play_Card:
		_on_hitbox_mouse_exited()

func _on_hitbox_mouse_exited():
	if !dragging && highlighted:
		highlighted = false
		z_index = 0

func _on_Hand_Hitbox_input_event(viewport, event, shape_idx):
	if state is Hand_Card:
		_on_hitbox_input_event(event)

func _on_Play_Hitbox_input_event(viewport, event, shape_idx):
	if state is Play_Card:
		_on_hitbox_input_event(event)

func _on_hitbox_input_event(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if !Globals.dragging && Globals.can_play && Globals.turn_of == player && event.pressed:
			Globals.dragging = true
			dragging = true
			z_index = 20
		elif dragging && Globals.can_play && Globals.turn_of == player:
			Globals.dragging = false
			dragging = false
			z_index = 0
			emit_signal("drop", self)