extends Spatial

var interface = null

# Called when the node enters the scene tree for the first time.
func _ready():
	interface = ARVRServer.find_interface("OpenVR")
	if interface and interface.initialize():
		# Make sure Godot knows the size of our viewport, else this is only known inside of the render driver
		$"Viewport-VR".size = interface.get_render_targetsize()
		
		# Tell our viewport it is the arvr viewport
		$"Viewport-VR".arvr = true
		
		# Uncomment this if you are using an older driver
		# $"Viewport-VR".hdr = false
		
		# turn off vsync
		OS.vsync_enabled = false
		
		# change our physics fps
		Engine.target_fps = 90
		
		# Tell our display what we want to display
		$"ViewportContainer/Viewport-UI".set_viewport_texture($"Viewport-VR".get_texture())

