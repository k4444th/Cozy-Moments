extends Area2D

var mouseOver = false
var dragging = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = !dragging	
	
	if event is InputEventMouseMotion and dragging:
		global_position += event.relative
