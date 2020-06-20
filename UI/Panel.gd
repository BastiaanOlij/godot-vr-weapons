tool
extends Spatial

signal pressed

export (Vector2) var size = Vector2(1.0, 1.0) setget set_size
export (Texture) var texture = null setget set_texture
export var collision_layer = 1 setget set_collision_layer

func set_size(new_size):
	size = new_size
	if $Body/Texture:
		$Body/Texture.mesh.size = size
	if $Body/CollisionShape:
		$Body/CollisionShape.shape.extents = Vector3(size.x * 0.5, size.y * 0.5, 0.01)

func set_texture(new_texture):
	texture = new_texture
	if $Body/Texture:
		$Body/Texture.get_surface_material(0).albedo_texture = texture

func set_collision_layer(new_layer):
	collision_layer = new_layer
	if $Body:
		$Body.collision_layer = 1 << (new_layer - 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_size(size)
	set_texture(texture)
	set_collision_layer(collision_layer)

func _on_Area_pressed(at):
	emit_signal("pressed")
