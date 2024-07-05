extends Control

@onready var rich_text_label := $RichTextLabel


func _ready() -> void:
	animate_rich_text_label()


func animate_rich_text_label() -> void:
	var tween := create_tween()
	var duration := 1.25
	
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, duration)


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
