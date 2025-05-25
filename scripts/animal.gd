extends Area2D

signal snapped_animal_position()

var mouseOver := false
var dragging := false
var overlap := false
var overlapCoords: Vector2

func _input(event):
	if event is InputEventMouseButton:
		if mouseOver and event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				dragging = true	
			else:
				dragging = false
				if overlap:
					global_position = overlapCoords
				emit_signal("snapped_animal_position")
	
	if event is InputEventMouseMotion and dragging:
		global_position += event.relative

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Workstation":
		overlap = true
		overlapCoords = area.global_position

func _on_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "Workstation":
		overlap = false

func _on_mouse_entered() -> void:
	mouseOver = true

func _on_mouse_exited() -> void:
	mouseOver = false
