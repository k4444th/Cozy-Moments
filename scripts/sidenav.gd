extends CanvasLayer

var buttonMargin := 15.0
var sidenavWidth := 250.0
var sidenavOpen := false
var openSidenavSpeed := 0.35

@onready var camera = $"../Camera2D"
@onready var sidenav = $Sidenav
@onready var arrowButton = $ArrowButton

func _ready() -> void:
	sidenav.size.x = sidenavWidth
	arrowButton.position = Vector2(sidenavWidth + buttonMargin, buttonMargin)
	
	arrowButton.flip_h = !sidenavOpen
	
	if sidenavOpen:
		camera.position.x = -(sidenavWidth / 2)
		sidenav.position.x = 0.0
		arrowButton.position.x = sidenavWidth + buttonMargin
	else:
		camera.position.x = 0
		sidenav.position.x = -sidenavWidth
		arrowButton.position.x = buttonMargin

func _on_arrow_button_pressed() -> void:
	sidenavOpen = !sidenavOpen
	arrowButton.flip_h = !sidenavOpen
	
	var cameraTween = get_tree().create_tween()
	var buttonTween = get_tree().create_tween()
	var sidenavTween = get_tree().create_tween()
	
	if sidenavOpen:
		cameraTween.tween_property(camera, "position:x", -(sidenavWidth / 2), openSidenavSpeed)
		buttonTween.tween_property(arrowButton, "position:x", sidenavWidth + buttonMargin, openSidenavSpeed)
		sidenavTween.tween_property(sidenav, "position:x", 0.0, openSidenavSpeed)
	else:
		cameraTween.tween_property(camera, "position:x", 0.0, openSidenavSpeed)
		buttonTween.tween_property(arrowButton, "position:x", buttonMargin, openSidenavSpeed)
		sidenavTween.tween_property(sidenav, "position:x", -sidenavWidth, openSidenavSpeed)
