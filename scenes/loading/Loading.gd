extends Spatial

export (NodePath) var follow_camera = null
export (Environment) var environment = null

var camera_node:Camera = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# get our camera node
	if follow_camera:
		camera_node = get_node(follow_camera)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera_node:
		# get our direction on our horizontal plane
		var view_dir = camera_node.global_transform.basis.z
		var dir_horz = Vector2(view_dir.x, view_dir.z).normalized()
		
		# now get our view angle and see how far we're off 
		var angle = dir_horz.angle_to(Vector2(0.0, 1.0))
		
		var delta_angle = angle - $Pivot.rotation.y
		if delta_angle < -PI:
			delta_angle += 2 * PI
		elif delta_angle > PI:
			delta_angle -= 2 * PI
		
		# and adjust our angle so we move our splash screen to the front
		$Pivot.rotation.y += delta_angle * delta
