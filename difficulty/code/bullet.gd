extends Area2D

const SPEED := 700.0
const MAX_DISTANCE := 4000.0
var travelled_distance := 0.0
var who_shot : String = ""


func _process(delta: float) -> void:
	var direction := Vector2.RIGHT.rotated(rotation)

	position += direction * SPEED * delta

	travelled_distance += SPEED * delta

	if travelled_distance >= MAX_DISTANCE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and who_shot == "player":
		body.health -= 1
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hurtbox"):
		queue_free()
		area.player.health -= 1
