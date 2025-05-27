extends Node

signal gameStarted()
signal roundStarted()
signal positionAnimal()
signal addNewAnimalToGame(animalIndex)
signal snapAnimalPositions(animalIndex)
signal addNewAnimalToSidenav(animalNode)

const SAVE_FILE_PATH := "user://cozymoments.json"
const ressourceList := ["berries", "wood", "tea"]
const animalList := ["Bear", "Bird", "Fox", "Frog", "Hedgehog", "Mouse", "Rabbit", "Raccoon"]
const workstationList := ["Berryforest", "Pond", "Stage", "Teahouse", "Wood", "Workbench"]
const newAnimalsPerRound := 3

var animalDistributionLength = 55

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
	saveGame()

func startGame():
	resetGame()
	spawnNewAnimals()
	emit_signal("gameStarted")
	
func nextRound():
	currentRound["round"] += 1
	spawnNewAnimals()
	saveGame()
	emit_signal("roundStarted")

func spawnNewAnimals():
	for newAnimalIndex in range(newAnimalsPerRound):
		currentRound["availableAnimals"].append({
			"name": animalList[randi_range(0, len(animalList) - 1)],
			"state": "new",
			"index": len(currentRound["availableAnimals"]),
			"position": Vector2(0.0, 0.0)
		})

func distributeAnimalsInWorkstation(animalIndex: int):
	emit_signal("snapAnimalPositions", animalIndex)

func positionAnimals():
	emit_signal("positionAnimal")
	
func addAnimalToSidenav(animalNode: Node2D):
	emit_signal("addNewAnimalToSidenav", animalNode)

func removeAnimalFromSidenav(animalIndex: int):
	emit_signal("addNewAnimalToGame", animalIndex)
