tool
extends MultiMeshInstance

# Helper tool to randomly position our stones whenever we change distance or scale in the editor
# new positions should be saved as part of the scene

export (float) var distance = 300.0 setget set_distance
export (float) var min_scale = 0.1 setget set_min_scale
export (float) var max_scale = 0.8 setget set_max_scale

var is_ready = false

func set_distance(new_distance):
	distance = new_distance
	if is_ready:
		_randomize()

func set_min_scale(new_scale):
	min_scale = new_scale
	if is_ready:
		_randomize()

func set_max_scale(new_scale):
	max_scale = new_scale
	if is_ready:
		_randomize()

func _randomize():
	for i in range(0, multimesh.instance_count):
		var t = Transform()
		t.basis = t.basis.rotated(Vector3(1.0,1.0,1.0).normalized(),rand_range(0.0, 4.0))
		t.basis = t.basis.scaled(Vector3(rand_range(min_scale, max_scale), rand_range(min_scale, max_scale), rand_range(min_scale, max_scale)))
		t.origin = Vector3(rand_range(-distance, distance),0.0,rand_range(-distance, distance))
		while t.origin.length() > distance:
			# stay within a circle...
			t.origin = Vector3(rand_range(-distance, distance),0.0,rand_range(-distance, distance))

		multimesh.set_instance_transform(i, t)

# Called when the node enters the scene tree for the first time.
func _ready():
	is_ready = true
