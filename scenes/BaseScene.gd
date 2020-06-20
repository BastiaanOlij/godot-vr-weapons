extends Spatial

signal change_world(to_scene)

export (Environment) var environment = null
export (bool) var enable_movement = true
export (bool) var enable_pickup = true
export (bool) var enable_pointer = true

var player_node = null

func init_world(new_player_node):
	# implement in subclass if applicable, make sure to call this too
	player_node = new_player_node
	player_node.enable_movement = enable_movement
	player_node.enable_pickup = enable_pickup
	player_node.enable_pointer = enable_pointer
	player_node.position_player($PlayerSpawnPoint.transform)

func exit_world():
	# implement in subclass if applicable
	pass

func _on_Panel_pressed():
	emit_signal("change_world", "res://scenes/shooting_range/Shooting_Range.tscn")

func _on_SelectDesertRange_pressed():
	emit_signal("change_world", "res://scenes/outdoor_desert/outdoor_desert.tscn")
