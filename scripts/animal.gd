extends Area2D

var mouseOver := false
var dragging := false
var overlap := false
var overlapCoords: Vector2

@export var state: String
@export var animalIndex: int

func _ready() -> void:
	Gamemanager.connect("positionAnimal", Callable(self, "positionSelf"))

func _input(event):
	if event is InputEventMouseButton and mouseOver and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and state == "sidenav":
			state = "addToGame"
			Gamemanager.currentRound["availableAnimals"][animalIndex].state = state
			Gamemanager.removeAnimalFromSidenav(animalIndex)
		elif state == "inGame":
			if mouseOver and event.button_index == MOUSE_BUTTON_LEFT:
				if event.is_pressed():
					dragging = true	
				else:
					dragging = false
					if overlap:
						global_position = overlapCoords
					Gamemanager.currentRound["availableAnimals"][animalIndex].position = global_position
					Gamemanager.distributeAnimalsInWorkstation(animalIndex)

	if event is InputEventMouseMotion and dragging:
		if state == "inGame":
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

func positionSelf():
	if state == "inGame":
		global_position = Gamemanager.currentRound["availableAnimals"][animalIndex].position
