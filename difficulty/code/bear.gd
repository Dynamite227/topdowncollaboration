extends CharacterBody2D

const SPEED := 170.0
const MAX_HEALTH := 6

@onready var player = get_node("/root/GameScene/Player")
@onready var health_bar: ProgressBar = $UI/Health/HealthBar
@onready var smoke_scene := preload("res://smoke_explosion/smoke_explosion.tscn")

var health := 6


func _ready() -> void:
	health_bar.max_value = MAX_HEALTH


func _process(_delta: float) -> void:
	handle_movement()
	
	if health <= 0:
		queue_free()
		var smoke := smoke_scene.instantiate()
		smoke.global_position = global_position
		get_parent().add_child(smoke)
		
	health_bar.value = health
	
	
func handle_movement() -> void:
	var direction := global_position.direction_to(player.global_position)
	
	if player.is_alive:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
	health_bar.value = health
	

func _on_hurtbox_detection_body_entered(body) -> void: #checks if the player touched the enemy
	if body.is_in_group("player"):
		player.hide()
		player.is_alive = false
