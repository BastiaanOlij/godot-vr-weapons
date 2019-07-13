extends "res://addons/godot-openvr/scenes/ovr_controller.gd"

func _on_Function_Pickup_has_picked_up(what):
	# use self to make sure we call our property setter
	self.show_controller_mesh = false

func _on_Function_Pickup_has_dropped():
	# use self to make sure we call our property setter
	self.show_controller_mesh = true
