extends Area2D

var speed := 350.0
var screensize = Vector2(480, 720)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal pickup(type)

func _ready() -> void:
	$CollisionShape2D.set_deferred("disabled", true)

func _process(delta: float) -> void:
	var move_dir = Input.get_vector("left", "right", "up", "down")
	position += move_dir * speed * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	if move_dir.length() > 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	if move_dir.x != 0:
		animated_sprite_2d.flip_h = move_dir.x < 0 

func start_game():
	set_process(true)
	animated_sprite_2d.play("idle")
	$CollisionShape2D.set_deferred("disabled", false)

func die():
	set_process(false)
	animated_sprite_2d.play("hurt")
	$CollisionShape2D.set_deferred("disabled", true)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		pickup.emit("coin")
		area.pickup()
	if area.is_in_group("powerups"):
		pickup.emit("powerup")
		area.pickup()
	if area.is_in_group("obstacles"):
		pickup.emit("obstacle")
