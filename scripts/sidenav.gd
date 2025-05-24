extends CanvasLayer

var sidenavOpen := true
var openSidenavSpeed := 0.35

@onready var sidenav = $Sidenav
@onready var arrowButton = $ArrowButton

func _on_arrow_button_pressed() -> void:
	sidenavOpen = !sidenavOpen
	arrowButton.flip_h = !sidenavOpen
	
	var sidenavTween = get_tree().create_tween()
	var buttonTween = get_tree().create_tween()
	
	if sidenavOpen:
		sidenavTween.tween_property(sidenav, "position:x", 0.0, openSidenavSpeed)
		buttonTween.tween_property(arrowButton, "position:x", 265.0, openSidenavSpeed)
		#sidenav.position.x = 0.0
		#arrowButton.position.x = 265.0
	else:
		sidenavTween.tween_property(sidenav, "position:x", -250.0, openSidenavSpeed)
		buttonTween.tween_property(arrowButton, "position:x", 15.0, openSidenavSpeed)
		#sidenav.position.x = -250.0
		#arrowButton.position.x = 15.0
