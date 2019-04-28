extends "res://addons/vr-common/objects/Object_pickable.gd"

export (PackedScene) var casing = null
export var initial_casing_velocity = 5.0
export var ammunition = 12

export var rumble = 0.0 setget set_rumble, get_rumble

func set_rumble(new_value):
	if by_controller:
		by_controller.rumble = new_value

func get_rumble():
	if by_controller:
		return by_controller.rumble
	else:
		return 0.0

func action():
	if !$AnimationPlayer.is_playing():
		if ammunition > 0:
			ammunition = ammunition - 1
			$AnimationPlayer.play("Fire")
			
			if $Aim.is_colliding():
				var what_did_we_hit = $Aim.get_collider()
				if what_did_we_hit.has_method("hit"):
					what_did_we_hit.hit($Aim.get_collision_point())
		else:
			$AnimationPlayer.play("EmptyClick")

func _process(delta):
	if $Aim.is_colliding():
		$Aim/Target_dot.global_transform.origin = $Aim.get_collision_point()
		$Aim/Target_dot.visible = true
	else:
		$Aim/Target_dot.visible = false

func _emit_casing():
	var new_casing = casing.instance()
	new_casing.transform = $Pivot/Casing_spawn_point.global_transform
	new_casing.linear_velocity = new_casing.transform.basis.x * initial_casing_velocity
	
	get_node("/root/Main/Viewport-VR/Spawns").add_child(new_casing)