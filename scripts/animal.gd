extends Area2D

var dragging := false
var overlap := false
var overlapCoords: Vector2

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = !dragging	
	
	if event is InputEventMouseMotion and dragging:
		global_position += event.relative

func _process(_delta: float) -> void:
	if overlap and !dragging:
		global_position = overlapCoords

func _on_area_entered(area: Area2D) -> void:
	if area.name ==  "Workstation":
		overlap = true
		overlapCoords = area.global_position

func _on_area_exited(area: Area2D) -> void:
	if area.name ==  "Workstation":
		overlap = false
