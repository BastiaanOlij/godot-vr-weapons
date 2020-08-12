extends "res://addons/godot-xr-tools/objects/Object_pickable.gd"

export var enabled = false setget set_enabled

onready var original_transform = transform

func set_enabled(new_enabled):
	enabled = new_enabled
	
	if is_picked_up() and !enabled:
		let_go()
	
	if $CollisionShape:
		$CollisionShape.disabled = !enabled

func pick_up(by, with_controller):
	.pick_up(by, with_controller)
	
	var hand = picked_up_by.get_hand()
	if hand:
		hand.visible = false


func let_go(starting_linear_velocity = Vector3(0.0, 0.0, 0.0)):
	if picked_up_by:
		var hand = picked_up_by.get_hand()
		if hand:
			hand.visible = true
		
		picked_up_by.remove_child(self)
		original_parent.add_child(self)
		
		transform = original_transform
		collision_mask = original_collision_mask
		collision_layer = original_collision_layer
		
		# we are no longer picked up
		picked_up_by = null
		by_controller = null


func _ready():
	set_enabled(enabled)
