extends Node2D

@export var player: Area2D 
@export var coins: PackedScene
@export var powerup: PackedScene
@export var cactus: PackedScene
@export var playtime: int = 30
var time = playtime
var level := 1
var score := 0
var playing := false
var hit_count := 0
var powerup_cont = 0
signal resetcount
@onready var viewport = get_viewport().get_visible_rect().size
@onready var game_time: Timer = $GameTime
@onready var hud: CanvasLayer = $HUD
var difficult : int = 1

func _ready() -> void:
	$SafeArea.position = viewport/2
	player.visible = false
	player.set_process(false)
	player.position = viewport/2
	respawn_cactus()


func _process(_delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time += 5
		spawn_coins()
		$PowerupTimer.wait_time = randf_range(5, 10)
		$PowerupTimer.start()

func _on_hud_game_start() -> void:
	player.visible = true
	player.start_game()
	game_time.start()
	new_game()

#Aqui eu checo so quando chamar o timeout e n em todo tick
func _on_game_time_timeout() -> void:
	time -= 1
	hud.update_time(time)
	if time <= 0:
		game_over()

func game_over():
	player.die()
	game_time.stop()
	hud.hud_game_over()
	playing = false
	get_tree().call_group("coins", "queue_free")
	$PowerupTimer.stop()
	$GameOverSound.play()

func new_game():
	player.position = viewport/2
	score = 0
	level = 1
	powerup_cont = 0
	time = playtime
	playing = true
	hud.update_time(time)
	hud.update_score(score)
	spawn_coins()

func spawn_coins():
	$NewLevelSound.play()
	powerup_cont += 1
	if powerup_cont >= 5:
		spawn_powerup()
	for i in level + 3 + difficult:
		var c := coins.instantiate()
		add_child(c)
		c.position = Vector2(randi_range(10, viewport.x - 10), randi_range(10, viewport.y - 10))

func _on_player_pickup(type: Variant) -> void:
	match type:
		"coin":
			score += 1
			$CoinSound.play()
			hud.update_score(score)
		"powerup":
			resetcount.emit()
			time += 5
			$PowerupSound.play()
			hud.update_time(time)
		"obstacle": 
			game_over()

func _on_powerup_timer_timeout() -> void:
	spawn_powerup()

func spawn_powerup():
	var p := powerup.instantiate()
	add_child(p)
	p.position = Vector2(randi_range(10, viewport.x - 10), randi_range(10, viewport.y - 10))

func _on_resetcount() -> void:
	powerup_cont = 0

func respawn_cactus():
	get_tree().call_group("obstacles", "queue_free")
	for i in 2 + difficult:
		var c = cactus.instantiate()
		$Node2D.add_child(c)
		c.position = Vector2(randi_range(10, viewport.x - 10), randi_range(10, viewport.y - 10))

func _on_hud_minus() -> void:
	difficult = hud.difficult
	respawn_cactus()

func _on_hud_plus() -> void:
	difficult = hud.difficult
	respawn_cactus()
