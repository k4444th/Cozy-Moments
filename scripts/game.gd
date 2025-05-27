extends Node2D

@onready var animalContainer = $Animals
@onready var workstationContainer = $Workstation

@onready var animalScenes := [
	preload("res://scenes/animals/bear.tscn"),
	preload("res://scenes/animals/bird.tscn"),
	preload("res://scenes/animals/fox.tscn"),
	preload("res://scenes/animals/frog.tscn"),
	preload("res://scenes/animals/hedgehog.tscn"),
	preload("res://scenes/animals/mouse.tscn"),
	preload("res://scenes/animals/rabbit.tscn"),
	preload("res://scenes/animals/raccoon.tscn"),
]

func _ready() -> void:
	Gamemanager.connect("gameStarted", Callable(self, "setup"))
	Gamemanager.connect("roundStarted", Callable(self, "setup"))
	Gamemanager.connect("addNewAnimalToGame", Callable(self, "addAnimalToGame"))
	Gamemanager.connect("snapAnimalPositions", Callable(self, "distributeAnimalsInWorkstation"))
	Gamemanager.startGame()

func setup():
	showAnimalsInSidenav()

func showAnimalsInSidenav():
	for animal in Gamemanager.currentRound["availableAnimals"]:
		if animal.state == "new":
			var animalNode = animalScenes[Gamemanager.animalList.find(animal.name)].instantiate()
			animalNode.state = animal.state
			animalNode.animalIndex = animal.index
			Gamemanager.addAnimalToSidenav(animalNode)

func addAnimalToGame(animalIndex):
	Gamemanager.currentRound["availableAnimals"][animalIndex].state = "inGame"
	for animal in Gamemanager.currentRound["availableAnimals"]:
		if animal.index == animalIndex:
			var animalNode = animalScenes[Gamemanager.animalList.find(animal.name)].instantiate()
			animalNode.position = animal.position
			animalNode.state = animal.state
			animalNode.animalIndex = animal.index
			animalContainer.add_child(animalNode)

func updateWorkstationHostAnimals(animalIndex: int):
	var workstations = workstationContainer.get_children()
	for workstation in workstations:
		if workstation.hostAnimals.find(animalIndex) >= 0:
			workstation.hostAnimals.pop_at(workstation.hostAnimals.find(animalIndex))
		if workstation.global_position.distance_to(Gamemanager.currentRound["availableAnimals"][animalIndex].position) <= Gamemanager.animalDistributionLength:
			workstation.hostAnimals.append(animalIndex)

func distributeAnimals():
	var workstations = workstationContainer.get_children()
	for workstation in workstations:
		var host_animals = workstation.hostAnimals
		var animalCount = host_animals.size()

		for i in range(animalCount):
			var animalIndex = host_animals[i]
			if animalCount > 1:
				var angle = deg_to_rad(i * 360.0 / animalCount)
				var offset = Vector2(
					Gamemanager.animalDistributionLength * sin(angle),
					Gamemanager.animalDistributionLength * cos(angle)
				)
				Gamemanager.currentRound["availableAnimals"][animalIndex].position = workstation.global_position + offset
			else:
				Gamemanager.currentRound["availableAnimals"][animalIndex].position = workstation.global_position

	Gamemanager.positionAnimals()

func distributeAnimalsInWorkstation(animalIndex: int):
	updateWorkstationHostAnimals(animalIndex)
	distributeAnimals()
	
