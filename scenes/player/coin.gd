extends Area2D

var screensize = Vector2(480, 720)

func _ready() -> void:
	# Fazer dessa forma iniica o timer imediatamente com o tempo especificado
	# Ele só tera esse wait_time nessa execução, quando for chamado novamente terá outro wait_time
	$Timer.start(randf_range(0.8, 7.0))

func pickup():
	$CollisionShape2D.set_deferred("disabled", true)
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", scale * 3, 0.3)
	tw.tween_property(self, "modulate:a", 0.0, 0.3)
	await tw.finished #Espera a animação finalizar para excluir 
	queue_free()

	# Evita que a moeda spawne em cima de um obstaculo
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles"):
		self.position = Vector2(randi_range(0, screensize.x),randi_range(0, screensize.y))

# Quando o timer finalizar, ele rodara a animação de forma aleatória (Já que o timer tem um wait_time aleatório)
func _on_timer_timeout() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()
