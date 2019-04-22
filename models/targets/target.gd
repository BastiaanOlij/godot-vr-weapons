extends StaticBody

var vp_material

func reset_target():
	$Viewport/Background.visible = true
	$Viewport/BulletHole.visible = false
	$Viewport.render_target_update_mode = Viewport.UPDATE_ONCE

func hit(p_at):
	# We hit our target at the position specified
	var t = global_transform
	var at = t.xform_inv(p_at)
	
	# Adjust from our 3D coordinates to 2D coordinates in our viewport
	at.x = (0.5 - (at.z / 1.0)) * 512.0
	at.y = (0.5 - (at.y / 2.0)) * 1024.0
	
	# Position our bullet hole at these coordinates
	$Viewport/BulletHole.rect_position = Vector2(at.x - 32.0, at.y - 32.0)
	
	# Now render the bullet hole
	$Viewport/Background.visible = false
	$Viewport/BulletHole.visible = true
	$Viewport.render_target_update_mode = Viewport.UPDATE_ONCE

# Called when the node enters the scene tree for the first time.
func _ready():
	vp_material = SpatialMaterial.new()
	vp_material.albedo_texture = $Viewport.get_texture()
	$MeshInstance.material_override = vp_material

