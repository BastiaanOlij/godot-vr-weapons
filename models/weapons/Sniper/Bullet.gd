extends RigidBody

export (Material) var material = null

onready var spawn_point = get_node("/root/Main/Viewport-VR/Spawns")

var last_position = Vector3()
var delta_position = Vector3()

func _add_test_object():
	var mesh = CapsuleMesh.new()
	mesh.radius = 0.01
	mesh.mid_height = $CollisionShape.shape.height + 0.08
	
	var new_object = MeshInstance.new()
	new_object.mesh = mesh
	spawn_point.add_child(new_object)
	new_object.global_transform = $CollisionShape.global_transform
	new_object.set_surface_material(0, material)

func set_start_transform(t):
	delta_position = linear_velocity / Engine.iterations_per_second
	$CollisionShape.shape.height = clamp(delta_position.length()-0.1, 0.0, 100.0)
	
	t.origin += delta_position * 0.5
	global_transform = t
	last_position = t.origin
	
	# _add_test_object()

func _on_Lifetime_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	print("test " + body.get_path())
	if body.has_method("hit"):
		body.hit(global_transform.origin, delta_position)
		
		queue_free()

func _physics_process(delta):
	var new_position = global_transform.origin
	if new_position != last_position:
		delta_position = new_position - last_position
		last_position = new_position
		
		look_at(new_position + delta_position, Vector3.UP)
		
		$CollisionShape.shape.height = clamp(delta_position.length()-0.1, 0.0, 100.0)
		
		# _add_test_object()
