extends CanvasLayer

var sidenavOpen := true
var buttonMargin := 15.0
var sidenavWidth := 250.0
var sidenavContentWidth := 200
var openSidenavSpeed := 0.35
var availableRessources := 0
var animalScale = 0.2
var animalSize = 256 * animalScale
var animalsPerRow = 3
var monthTextures = [
	preload("res://assets/mock/sidenav/Calendar/CalendarJan.png"),
	preload("res://assets/mock/sidenav/Calendar/CalendarFeb.png"),
	preload("res://assets/mock/sidenav/Calendar/CalendarMar.png"),
	preload("res://assets/mock/sidenav/Calendar/CalendarApr.png"),
	preload("res://assets/mock/sidenav/Calendar/CalendarMay.png"),
	preload("res://assets/mock/sidenav/Calendar/CalendarJun.png"),
	preload("res://assets/mock/sidenav/Calendar/CalendarJul.png"),
	preload("res://assets/mock/sidenav/Calendar/CalendarAug.png"),
	preload("res://assets/mock/sidenav/Calendar/CalendarSep.png"),
	preload("res://assets/mock/sidenav/Calendar/CalendarOct.png"),
	preload("res://assets/mock/sidenav/Calendar/CalendarNov.png"),
	preload("res://assets/mock/sidenav/Calendar/CalendarDec.png")
]

@onready var camera := $"../Camera2D"
@onready var everything := $Everything
@onready var sidenav := $Everything/Sidenav
@onready var arrowButton := $Everything/ArrowButton
@onready var calendar := $Everything/CalendarButton
@onready var ressources := $Everything/Ressources
@onready var animals := $Everything/Animals

@onready var ressourceScene := preload("res://scenes/ressource.tscn")

func _ready() -> void:
	Gamemanager.connect("addNewAnimalToSidenav", Callable(self, "addAnimalToGUI"))
	Gamemanager.connect("addNewAnimalToGame", Callable(self, "removeAnimalFromGUI"))
	get_viewport().size_changed.connect(resize)
	initSizes()
	initPositions()
	initTextures()
	initRessources()

func initSizes():
	sidenav.size = Vector2(sidenavWidth, get_viewport().get_visible_rect().size.y)
	arrowButton.position = Vector2(sidenavWidth + buttonMargin, buttonMargin)
	calendar.scale = Vector2(sidenavContentWidth / 256.0, sidenavContentWidth / 256.0)
	calendar.position = Vector2((sidenavWidth - sidenavContentWidth) / 2, (sidenavWidth - sidenavContentWidth) / 2)
	ressources.position = Vector2(sidenavWidth + buttonMargin, get_viewport().get_visible_rect().size.y - 64 - buttonMargin)
	animals.position = Vector2((sidenavWidth - sidenavContentWidth) / 2 + animalSize / 2, calendar.size.y * calendar.scale.y + (sidenavWidth - sidenavContentWidth) / 2 + animalSize)

func initPositions():
	arrowButton.flip_h = !sidenavOpen
	
	if sidenavOpen:
		camera.position.x = -(sidenavWidth / 2)
		everything.position.x = 0.0
	else:
		camera.position.x = 0
		everything.position.x = -sidenavWidth

func initTextures():
	calendar.texture_normal = monthTextures[Gamemanager.currentRound["round"]]

func initRessources():
	for ressource in Gamemanager.ressourceList:
		if Gamemanager.currentRound[ressource] > 0:
			addRessourceToGUI(ressource, availableRessources)
			availableRessources += 1

func addRessourceToGUI(ressource: String, index: int):
	var ressourceNode = ressourceScene.instantiate()
	ressourceNode.position.x = index * (128 + buttonMargin)
	ressourceNode.get_child(1).text = str(int(Gamemanager.currentRound[ressource]))
	get_node("/root/Game/Sidenav/Everything/Ressources").add_child(ressourceNode)

func addAnimalToGUI(animalNode):
	var currentlyAvailableAnimals = len(animals.get_children())
	animalNode.state = "sidenav"
	Gamemanager.currentRound["availableAnimals"][animalNode.animalIndex].state = animalNode.state
	animalNode.scale = Vector2(animalScale, animalScale)
	animalNode.position = Vector2((animalSize + (sidenavContentWidth - 3 * animalSize) / 2) * (currentlyAvailableAnimals % animalsPerRow), (animalSize + buttonMargin) * floor((currentlyAvailableAnimals) / animalsPerRow))
	animals.add_child(animalNode)

func removeAnimalFromGUI(animalIndex):
	var animalNodes = animals.get_children()
	for animalNode in animalNodes:
		if animalNode.animalIndex == animalIndex:
			animals.remove_child(animalNode)

func resize():
	initSizes()

func updateCalendarButton():
	calendar.texture_normal = monthTextures[Gamemanager.currentRound["round"]]

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
	Gamemanager.nextRound()
	if Gamemanager.currentRound["round"] < 12:
		updateCalendarButton()
	else:
		print("Game over!")
