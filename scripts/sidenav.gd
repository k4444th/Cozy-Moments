extends CanvasLayer

var sidenavOpen := true
var buttonMargin := 15.0
var sidenavWidth := 250.0
var sidenavContentWidth := 200
var openSidenavSpeed := 0.35
var availableRessources := 0
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

@onready var ressourceScene := preload("res://scenes/ressource.tscn")

func _ready() -> void:
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
	for ressource in Gamemanager.ressources:
		if Gamemanager.currentRound[ressource] > 0:
			addRessourceToGUI(ressource, availableRessources)
			availableRessources += 1

func addRessourceToGUI(ressource: String, index: int):
	var ressourceNode = ressourceScene.instantiate()
	ressourceNode.position.x = index * (128 + buttonMargin)
	ressourceNode.get_child(1).text = str(int(Gamemanager.currentRound[ressource]))
	get_node("/root/Game/Sidenav/Everything/Ressources").add_child(ressourceNode)

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
