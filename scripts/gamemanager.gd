extends Node

signal round_started()

const SAVE_FILE_PATH := "user://cozymoments.json"
const ressourceList := ["berries", "wood", "tea"]
const animalList := ["Bear", "Bird", "Fox", "Frog", "Hedgehog", "Mouse", "Rabbit", "Raccoon"]
const workstationList := ["Berryforest", "Pond", "Stage", "Teahouse", "Wood", "Workbench"]
const newAnimalsPerRound := 3

var animalDistributionLength = 50

@onready var animalScene := preload("res://scenes/animal.tscn")

var currentRound := {
	"round": 0,
	"memories": 0,
	"berries": 0,
	"wood": 0,
	"tea": 0,
	"availableAnimals": []
}

func _ready() -> void:
	resetGame()
	loadGame()
	var animalNode = animalScene.instantiate()
	animalNode.connect("snapped_animal_position", Callable(self, "distributeAnimals"))
	add_child(animalNode	)

func saveGame():
	var data = {
		"currentRound": currentRound
	}
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func loadGame():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		var content = file.get_as_text()
		file.close()

		var loadedData = JSON.parse_string(content)
		if typeof(loadedData) == TYPE_DICTIONARY:
			currentRound = loadedData.get("currentRound", {
					"round": 0,
					"memories": 0,
					"berries": 0,
					"wood": 0,
					"tea": 0,
					"availableAnimals": []
				}
			)

func resetGame():
	currentRound["round"] = 0
	currentRound["memories"] = 0
	currentRound["berries"] = 0
	currentRound["wood"] = 0
	currentRound["tea"] = 0
	currentRound["availableAnimals"] = []
	spawnNewAnimals()
	saveGame()

func nextRound():
	currentRound["round"] += 1
	spawnNewAnimals()
	saveGame()
	emit_signal("round_started")

func spawnNewAnimals():
	for newAnimal in range(newAnimalsPerRound):
		currentRound["availableAnimals"].append({
			"name": animalList[randi_range(0, len(animalList) - 1)],
			"state": "new",
			"position": Vector2(0.0, 0.0)
		})

func distributeAnimals(callerPos):
	var animals = get_node("/root/Game/Animals").get_children()
	var positions = []
	var duplicates = []
	
	for animal in animals:
		positions.append(animal.global_position)
	
	for pos in positions:
		var amount = positions.count(pos)
		if amount > 1:
			var positionToAdd = {
				"position": pos,
				"amount": amount
			}
			if not duplicates.has(positionToAdd):
				duplicates.append(positionToAdd)
	
	for index in range(animals.size()):
		var animal = animals[index]
		for pos in duplicates:
			if animal.global_position == pos.position:
				animal.global_position = Vector2(animal.global_position.x + animalDistributionLength * sin (deg_to_rad(index * 360.0 / pos.amount)), animal.global_position.y + animalDistributionLength * cos (deg_to_rad(index * 360.0 / pos.amount)))
				print(animal.global_position)
