extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_scope(value):
	$Label.text = 'Scope: ' + str(int(value))
