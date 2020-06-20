extends StaticBody

signal pressed(at)

func pointer_pressed(at):
	emit_signal("pressed", at)

func pointer_entered():
	if $Texture:
		$Texture.get_surface_material(0).albedo_color = Color(0.8, 0.8, 1.0, 1.0)

func pointer_exited():
	if $Texture:
		$Texture.get_surface_material(0).albedo_color = Color(1.0, 1.0, 1.0, 1.0)
