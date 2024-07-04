extends RigidBody2D

@onready var weapon_holder := $WeaponHolder
@onready var timer: Timer = $Timer
@onready var gun := $"WeaponHolder/Gun"
@onready var shotSfx := $"gunshot"
@onready var mainView := $"../mainView"
var is_alive = true
var knockback = Vector2(1,1)
@export var borderOffset = 200



func _physics_process(_delta: float) -> void:
	# Didn't clutter up the _physics_process() function.
	handle_holder_rotation()
	mouseClick()
	deathBorder()
	if is_alive == false:
		hide()

# This function checks if the player is outside the screen, then kills them if they are with an offset to make it look better.
func deathBorder():
	var viewPort = mainView.get_viewport_rect().size 
	if position.y > (viewPort.y + mainView.position.y - borderOffset):
		is_alive = false
	elif position.y < (-viewPort.y - mainView.position.y + borderOffset):
		is_alive = false
	elif position.x > (viewPort.x + mainView.position.y - borderOffset):
		is_alive = false
	elif position.x < (-viewPort.x - mainView.position.y + borderOffset):
		is_alive = false
		
	


func handle_holder_rotation():
	# This line of code makes the weapon look at the position of the mouse
	# on the screen enabling the player to aim.
	weapon_holder.look_at(get_global_mouse_position())





func move_player():
	# get_parent() references the player node. Cause this node's parent
	# is the Player itself.
	

	# This sets the direction of the player to the opposite of the rotation of the weapon.

	# This is necessary so that the player moves backward to the rotation of the weapon.
	var direction: Vector2 = Vector2.LEFT.rotated(weapon_holder.rotation) * 400.0

	# Timer is used to that player doesn't keep on moving forever when we click.

	# TRY: Comment the timer.start(), await player.timer.timeout and the lines after it to see the results for yourself.
	timer.start()
	apply_central_impulse(knockback * direction)

	await timer.timeout


func mouseClick():
	if Input.is_action_just_pressed("left_click"):
		# Code to execute when left mouse button is clicked
		shotSfx.play()
		gun.shoot_bullet("player")
		move_player()

