extends Area2D
var screensize = Vector2(480, 720)

#Evitando que o cacto fique em cima de outro cacto e da safe area
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles") or area.is_in_group("safe"):
		self.position = Vector2(randf_range(0, screensize.x), randf_range(0, screensize.y))
