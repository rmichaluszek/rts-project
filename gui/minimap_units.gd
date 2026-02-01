extends Control

func _ready() -> void:
	pass

func _draw():
	#units
	for c in get_parent().get_parent().get_parent().get_parent().get_node("Units").get_children():
		draw_rect(Rect2(c.position.x/64+get_parent().minimap_margin,c.position.y/64+get_parent().minimap_margin,2,2),Color.GREEN)

	# viewport rectangle
	var resolution = DisplayServer.window_get_size()
	resolution.x /= get_parent().camera.zoom.x
	resolution.y /= get_parent().camera.zoom.y
	draw_rect(Rect2(get_parent().camera.position.x/64-resolution.x/2/64+get_parent().minimap_margin,get_parent().camera.position.y/64-resolution.y/2/64+get_parent().minimap_margin,resolution.x/64,resolution.y/64),Color.WHITE,false)
	
