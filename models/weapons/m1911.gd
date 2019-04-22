extends "res://addons/vr-common/objects/Object_pickable.gd"

func action():
	if $Aim.is_colliding():
		var what_did_we_hit = $Aim.get_collider()
		if what_did_we_hit.has_method("hit"):
			what_did_we_hit.hit($Aim.get_collision_point())

func _process(delta):
	if $Aim.is_colliding():
		$Aim/Target_dot.global_transform.origin = $Aim.get_collision_point()
		$Aim/Target_dot.visible = true
	else:
		$Aim/Target_dot.visible = false

