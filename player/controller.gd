extends ARVRController

signal controller_activated(controller)

# Called when the node enters the scene tree for the first time.
func _ready():
	# hide to begin with
	visible = false

func _process(delta):
	if !get_is_active():
		visible = false
		return
	
	if visible:
		return
	
	# make it visible
	visible = true
	emit_signal("controller_activated", self)
