extends CharacterBody2D

const SPEED := 250.0
const MAX_HEALTH := 2

@onready var player = get_node("/root/GameScene/Player")
@onready var smoke_scene := preload("res://smoke_explosion/smoke_explosion.tscn")
@onready var gun := $WeaponHolder/Gun
@onready var weapon_holder = $WeaponHolder
@onready var time_between = $timeBetweenShots
@onready var enemyRange := $Range
@onready var health_bar: ProgressBar = $UI/Health/HealthBar

var health := 2
var follow_player := true


func _ready() -> void:
	
	time_between.start()
	health_bar.max_value = MAX_HEALTH


func _process(_delta: float) -> void:
	handle_holder_rotation()
	enemy_logic()
	handle_gunman_health()


func _on_hurtbox_detection_body_entered(body) -> void: #checks if the player touched the enemy
	if body.is_in_group("player"):
		player.hide()
		player.is_alive = false


func handle_holder_rotation() -> void:
	# This line of code makes the weapon look at the position of the mouse on the screen enabling the player to aim.
	weapon_holder.look_at(player.global_position)


func enemy_logic() -> void:
	var direction := global_position.direction_to(player.global_position)
	
	if follow_player == true:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
	health_bar.value = health


func _on_range_body_entered(_body: Node2D) -> void:
	if get_viewport_rect().has_point(self.global_position):
		follow_player = false
	



func _on_range_body_exited(_body: Node2D) -> void:
	follow_player = true



func _on_time_between_shots_timeout() -> void:
	gun.shoot_bullet("enemy")
	
	
func handle_gunman_health() -> void:
	if health <= 0:
		queue_free()
		var smoke := smoke_scene.instantiate()
		smoke.global_position = global_position
		get_parent().add_child(smoke)
