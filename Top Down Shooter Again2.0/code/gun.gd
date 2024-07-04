extends Sprite2D

@onready var bullet := preload("res://scenes/bullet.tscn")
@onready var shooting_point := $ShootingPoint


func shoot_bullet(shooter : String):
	var new_bullet: Area2D = bullet.instantiate()
	new_bullet.who_shot = shooter

	new_bullet.global_position = shooting_point.global_position
	new_bullet.global_rotation = shooting_point.global_rotation

	get_tree().get_root().add_child(new_bullet)
