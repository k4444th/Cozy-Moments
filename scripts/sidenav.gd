extends CanvasLayer

var sidenavOpen := false
var openSidenavSpeed := 0.35

@onready var camera = $"../Camera2D"
@onready var sidenav = $Sidenav
@onready var arrowButton = $ArrowButton

func _ready() -> void:
	arrowButton.flip_h = !sidenavOpen
	
	if sidenavOpen:
		camera.position.x = -125.0
		sidenav.position.x = 0.0
		arrowButton.position.x = 265.0
	else:
		camera.position.x = 0
		sidenav.position.x = -250.0
		arrowButton.position.x = 15.0

func _on_arrow_button_pressed() -> void:
	sidenavOpen = !sidenavOpen
	arrowButton.flip_h = !sidenavOpen
	
	var cameraTween = get_tree().create_tween()
	var buttonTween = get_tree().create_tween()
	var sidenavTween = get_tree().create_tween()
	
	if sidenavOpen:
		cameraTween.tween_property(camera, "position:x", -125.0, openSidenavSpeed)
		buttonTween.tween_property(arrowButton, "position:x", 265.0, openSidenavSpeed)
		sidenavTween.tween_property(sidenav, "position:x", 0.0, openSidenavSpeed)
	else:
		cameraTween.tween_property(camera, "position:x", 0.0, openSidenavSpeed)
		buttonTween.tween_property(arrowButton, "position:x", 15.0, openSidenavSpeed)
		sidenavTween.tween_property(sidenav, "position:x", -250.0, openSidenavSpeed)
