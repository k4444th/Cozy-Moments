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
	Gamemanager.connect("roundStarted", Callable(self, "distributeAnimalsInWorkstation"))
	Gamemanager.connect("snapAnimalPositions", Callable(self, "distributeAnimalsInWorkstation"))
	Gamemanager.startGame()
	showAnimals()

func showAnimals():
	for animal in Gamemanager.currentRound["availableAnimals"]:
		var animalNode = animalScenes[Gamemanager.animalList.find(animal.name)].instantiate()
		animalNode.position = animal.position
		animalNode.state = animal.state
		animalNode.animalIndex = animal.index
		animalContainer.add_child(animalNode)

func updateWorkstationHostAnimals(animalIndex: int):
	print(animalIndex)
	var workstations = workstationContainer.get_children()
	for workstation in workstations:
		if workstation.hostAnimals.find(animalIndex) >= 0:
			workstation.hostAnimals.pop_at(workstation.hostAnimals.find(animalIndex))
		if workstation.global_position.distance_to(Gamemanager.currentRound["availableAnimals"][animalIndex].position) <= Gamemanager.animalDistributionLength:
			workstation.hostAnimals.append(animalIndex)

func distributeAnimals():
	var workstations = workstationContainer.get_children()
	for workstation in workstations:
		var animalCount = len(workstation.hostAnimals)
		for animalIndex in workstation.hostAnimals:
			if animalCount > 1:
				Gamemanager.currentRound["availableAnimals"][animalIndex].position = workstation.global_position + Vector2(Gamemanager.animalDistributionLength * sin(deg_to_rad(animalIndex * 360.0 / animalCount)), Gamemanager.animalDistributionLength * cos(deg_to_rad(animalIndex * 360.0 / animalCount)))
			elif animalCount == 1:
				Gamemanager.currentRound["availableAnimals"][animalIndex].position = workstation.global_position
	Gamemanager.positionAnimals()

func distributeAnimalsInWorkstation(animalIndex: int):
	updateWorkstationHostAnimals(animalIndex)
	distributeAnimals()
	
