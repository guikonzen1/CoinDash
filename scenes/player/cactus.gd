extends Area2D
var screensize = Vector2(480, 720)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles") or area.is_in_group("safe"):
		self.position = Vector2(randf_range(0, screensize.x), randf_range(0, screensize.y))
