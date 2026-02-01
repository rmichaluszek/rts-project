extends Control

func _ready() -> void:
	pass

func _draw():
	for y in get_parent().map_size:
		for x in get_parent().map_size:
			if get_parent().minimap_static_data[y*get_parent().map_size+x] == Vector2i(1,0): # wall
				draw_rect(Rect2(x+get_parent().minimap_margin,y+get_parent().minimap_margin,2,2),Color.SADDLE_BROWN)
