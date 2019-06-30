extends "res://addons/vr-common/objects/Object_pickable.gd"

func _update_highlight():
	var material = $MeshInstance.get_surface_material(0)
	if closest_count > 0:
		material.set_shader_param("FresnelStrength", 1.0)
	else:
		material.set_shader_param("FresnelStrength", 0.0)
