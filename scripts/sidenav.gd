extends CanvasLayer

var sidenavOpen := true

@onready var sidenav = $Sidenav
@onready var arrowButton = $ArrowButton

func _on_arrow_button_pressed() -> void:
	sidenavOpen = !sidenavOpen
	arrowButton.flip_h = !sidenavOpen
	
	if sidenavOpen:
		sidenav.position.x = 0.0
		arrowButton.position.x = 265.0
	else:
		sidenav.position.x = -250.0
		arrowButton.position.x = 15.0
