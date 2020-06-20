extends "res://addons/godot-xr-tools/objects/Object_pickable.gd"

export (PackedScene) var bullet = null
export var initial_bullet_speed = 300.0

var can_shoot = true

func action():
	if can_shoot and bullet:
		# shoot our bullet
		var new_bullet = bullet.instance()
		get_node("/root/Main/Viewport-VR/Spawns").add_child(new_bullet)
		
		var new_transform = $Pivot/Muzzle.global_transform
		new_bullet.linear_velocity = -new_transform.basis.z * initial_bullet_speed
		new_bullet.set_start_transform(new_transform)
		
		# start cooldown
		can_shoot = false
		$cooldown.start()

func _on_cooldown_timeout():
	can_shoot = true
