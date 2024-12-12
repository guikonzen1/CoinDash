extends CanvasLayer

@onready var game_title: Label = $GameTitle
@export var player: Area2D
@onready var button: Button = $Button
signal game_start
signal reset
signal minus
signal plus
@onready var difficult_text: Label = $MarginContainer/Difficult
var difficult : int
@onready var game_over_timer: Timer = $GameOverTimer

func show_title():
	game_title.visible = !game_title.visible
	button.visible = !button.visible
	$MarginContainer.visible = !$MarginContainer.visible

func _on_button_pressed() -> void:
	show_title()
	game_start.emit()

func hud_game_over():
	show_message("GAME OVER!")
	await game_over_timer.timeout
	game_title.text = "COIN DASH!"
	show_title()

func show_message(text):
	game_title.text = text
	game_title.show()
	$GameOverTimer.start()

func _on_game_over_timer_timeout() -> void:
	game_title.hide()

func update_score(text:int):
	$HBoxContainer/Score.text = str(text)

func update_time(text:int):
	$HBoxContainer/Time.text = str(text)

func _on_respawn_pressed() -> void:
	reset.emit()

func _on_minus_pressed() -> void:
	if difficult_text.text == "1":
		pass
	elif difficult_text.text == "2":
		difficult_text.text = "1"
	elif difficult_text.text == "3":
		difficult_text.text = "2"
	difficult = int(difficult_text.text)
	minus.emit()

func _on_plus_pressed() -> void:
	if difficult_text.text == "3":
		pass
	elif difficult_text.text == "2":
		difficult_text.text = "3"
	elif difficult_text.text == "1":
		difficult_text.text = "2"
	difficult = int(difficult_text.text)
	plus.emit()
