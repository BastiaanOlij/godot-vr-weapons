extends "res://addons/godot-xr-tools/functions/Function_Pickup.gd"

export (NodePath) var hand = null

func get_hand():
	if hand:
		return get_node(hand)
	else:
		return null
