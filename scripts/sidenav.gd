extends CanvasLayer

var sidenavOpen := false
var buttonMargin := 15.0
var sidenavWidth := 250.0
var sidenavContentWidth := 200
var openSidenavSpeed := 0.35

@onready var everything = $Everything
@onready var sidenav = $Everything/Sidenav
@onready var camera = $"../Camera2D"
@onready var arrowButton = $Everything/ArrowButton
@onready var calendar = $Everything/CalendarButton

func _ready() -> void:	
	sidenav.size = Vector2(sidenavWidth, DisplayServer.screen_get_size().y)
	arrowButton.position = Vector2(sidenavWidth + buttonMargin, buttonMargin)
	calendar.scale = Vector2(sidenavContentWidth / 256.0, sidenavContentWidth / 256.0)
	calendar.position = Vector2((sidenavWidth - sidenavContentWidth) / 2, (sidenavWidth - sidenavContentWidth) / 2)
	
	arrowButton.flip_h = !sidenavOpen
	
	if sidenavOpen:
		camera.position.x = -(sidenavWidth / 2)
		everything.position.x = 0.0
	else:
		camera.position.x = 0
		everything.position.x = -sidenavWidth

func _on_arrow_button_pressed() -> void:
	sidenavOpen = !sidenavOpen
	arrowButton.flip_h = !sidenavOpen
	
	var cameraTween = get_tree().create_tween()
	var everythingTween = get_tree().create_tween()
	
	if sidenavOpen:
		cameraTween.tween_property(camera, "position:x", -(sidenavWidth / 2), openSidenavSpeed)
		everythingTween.tween_property(everything, "position:x", 0.0, openSidenavSpeed)
	else:
		cameraTween.tween_property(camera, "position:x", 0.0, openSidenavSpeed)
		everythingTween.tween_property(everything, "position:x", -sidenavWidth, openSidenavSpeed)

func _on_calendar_button_pressed() -> void:
	print("Next Round")
