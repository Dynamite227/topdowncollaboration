extends Area2D

@onready var player: RigidBody2D = get_node("/root/GameScene/Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#checks is the player touched the enemy
func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		player.hide()
		#kills the player

