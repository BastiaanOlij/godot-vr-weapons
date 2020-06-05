extends ARVROrigin

export (NodePath) var render_viewport = null
export var enable_movement = false setget set_enable_movement
export var enable_pickup = false setget set_enable_pickup
export var enable_pointer = false setget set_enable_pointer

# left = 0, right = 1
var pointer_on_hand = 1

var interface = null

func set_enable_movement(enabled : bool):
	enable_movement = enabled
	if $"Left hand/Function_Teleport":
		$"Left hand/Function_Teleport".enabled = enabled
	
	if $"Right hand/Function_Direct_movement":
		$"Right hand/Function_Direct_movement".enabled = enabled

func set_enable_pickup(enabled : bool):
	enable_pickup = enabled
	
	# need to implement enabled on our pickup function in xr-tools
	if $"Left hand/Function_Pickup":
		# $"Left hand/Function_Pickup".enabled = enabled
		pass
	
	if $"Right hand/Function_Pickup":
		# $"Right hand/Function_Pickup".enabled = enabled
		pass

func set_enable_pointer(enabled : bool):
	enable_pointer = enabled
	if $"Left hand/Function_pointer":
		$"Left hand/Function_pointer".enabled = enabled and pointer_on_hand == 0
	
	if $"Right hand/Function_pointer":
		$"Right hand/Function_pointer".enabled = enabled and pointer_on_hand == 1

func position_player(new_transform : Transform):
	# need to offset by our camera transform
	var t : Transform = $ARVRCamera.transform
	
	# remove height
	t.origin.y = 0
	
	# and remove tilt
	t.basis.y = Vector3.UP
	t.basis.z.y = 0.0
	if t.basis.z.length() == 0:
		t.basis.x = Vector3(1.0, 0.0, 0.0)
		t.basis.z = Vector3(0.0, 0.0, 1.0)
	else:
		t.basis.z = t.basis.z.normalized()
		t.basis.x = t.basis.y.cross(t.basis.z).normalized()
	
	# inverse this
	t = t.inverse()
	
	# and position
	global_transform = new_transform * t

# Called when the node enters the scene tree for the first time.
func _ready():
	interface = ARVRServer.find_interface("OpenVR")
	if interface and interface.initialize():
		var viewport = null
		if render_viewport:
			viewport = get_node(render_viewport)
		
		if !viewport:
			viewport = get_viewport()
		
		# Make sure Godot knows the size of our viewport, else this is only known inside of the render driver
		viewport.size = interface.get_render_targetsize()
		
		# Tell our viewport it is the arvr viewport
		viewport.arvr = true
		
		# Keep liniear so our HMD applies the right color balance
		viewport.keep_3d_linear = true
		
		# turn off vsync
		OS.vsync_enabled = false
		
		# change our physics fps
		Engine.iterations_per_second = 90
	
	# Enable this again when we re-introduce logic into xr-tools 
	# start our particles so our shaders get compiled
	# $"ARVRCamera/vr_common_shader_cache/Particles".emitting=true
	
	set_enable_movement(enable_movement)
	set_enable_pickup(enable_pickup)
	set_enable_pointer(enable_pointer)

# Enable this again when we re-introduce logic into xr-tools  
#func _on_vr_common_shader_cache_cooldown_finished():
#	$"ARVRCamera/vr_common_shader_cache/Particles".emitting=false
 
func _on_Left_hand_button_pressed(button):
	if button == $"Left hand/Function_pointer".active_button and enable_pointer and pointer_on_hand == 1:
		pointer_on_hand = 0
		set_enable_pointer(enable_pointer)

func _on_Right_hand_button_pressed(button):
	if button == $"Right hand/Function_pointer".active_button and enable_pointer and pointer_on_hand == 0:
		pointer_on_hand = 1
		set_enable_pointer(enable_pointer)
