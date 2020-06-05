extends "res://addons/godot-xr-tools/objects/Object_pickable.gd"

export (PackedScene) var casing = null
export (PackedScene) var smoke = null
export var initial_casing_velocity = 5.0
export var magazine_size = 12
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

func _update_highlight():
	var material = $Pivot/Gun/gunbody.mesh.surface_get_material(0)
	if closest_count > 0:
		material.set_shader_param("FresnelStrength", 1.0)
	else:
		material.set_shader_param("FresnelStrength", 0.0)

func set_ammunition(new_value):
	if ammunition != new_value:
		ammunition = new_value

		$Ammo_count_viewport/Ammo_count.text = str(ammunition)
		$Ammo_count_viewport.render_target_update_mode = Viewport.UPDATE_ONCE

func action():
	if !$AnimationPlayer.is_playing():
		if ammunition > 0:
			set_ammunition(ammunition - 1)
			$AnimationPlayer.play("Fire")
			_emit_smoke()

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

func _emit_smoke():
	var new_smoke = smoke.instance()
	new_smoke.transform = $Pivot/Smoke_spawn_point.global_transform

	get_node("/root/Main/Viewport-VR/Spawns").add_child(new_smoke)

func _on_Gun_load_point_body_entered(body):
	# our ammo is loaded, so we can destroy our magazine
	body.drop_and_free()

	# and reload
	set_ammunition(magazine_size)

	# and finally play reload animation
	$AnimationPlayer.play("Load")
