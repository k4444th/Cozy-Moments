extends Node

const SAVE_FILE_PATH := "user://cozymoments.json"
const ressources := ["berries", "wood", "tea"]

var currentRound := {
	"round": 0,
	"memories": 0,
	"berries": 0,
	"wood": 0,
	"tea": 0
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
					"tea": 0
				}
			)

func resetGame():
	currentRound["round"] = 0
	currentRound["memories"] = 0
	currentRound["berries"] = 0
	currentRound["wood"] = 0
	currentRound["tea"] = 0
	saveGame()

func nextRound():
	currentRound["round"] += 1
	saveGame()
