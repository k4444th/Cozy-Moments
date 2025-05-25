extends Node2D

@onready var animalContainer = $Animals

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
	Gamemanager.connect("round_started", Callable(self, "showAnimals"))
	showAnimals()

func showAnimals():
	print("hello")
	for animal in Gamemanager.currentRound["availableAnimals"]:
		var animalNode = animalScenes[Gamemanager.animalList.find(animal.name)].instantiate()
		animalContainer.add_child(animalNode)
