extends Viewport

export var target_fps = 30
var simulate_fps = 0.0

func set_viewport_texture(p_texture):
	$"VR-Preview".texture = p_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_resize()
	get_tree().get_root().connect("size_changed", self, "_on_resize")

func _on_resize():
	size = OS.get_window_size()

func _process(delta):
	simulate_fps += delta
	if simulate_fps > (1.0 / target_fps):
		simulate_fps = 0.0
		render_target_update_mode = Viewport.UPDATE_ONCE
		
		var texture_size = $"VR-Preview".texture.get_size()
		var texture_scale = size.x / texture_size.x
		$"VR-Preview".rect_size = texture_size * texture_scale
		$"VR-Preview".rect_position = (size - $"VR-Preview".rect_size) * 0.5
