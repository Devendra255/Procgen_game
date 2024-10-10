extends Control

@onready var line_edit: LineEdit = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	var num = line_edit.text
	if num != null and num != '':
		GlobalPara.set_seed(int(num))
	get_tree().change_scene_to_file("res://Scenes/generator.tscn")


func _on_line_edit_text_submitted(new_text: String) -> void:
	var num = line_edit.text
	if num != null and num != '':
		GlobalPara.set_seed(int(num))
	get_tree().change_scene_to_file("res://Scenes/generator.tscn")
