extends Panel

var minimap_margin = 2
var holding_left_click = false
var minimap_static_data = []
var map_size = 200

@onready var camera = get_parent().get_parent().get_parent().get_node("Camera")

func _ready() -> void:
	var data = [] 
	for y in map_size:
		for x in map_size:
			data.push_back(get_parent().get_parent().get_parent().get_node("Terrain/NavigationRegion2D/Base").get_cell_atlas_coords(Vector2(x,y)))
	minimap_static_data = data


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			holding_left_click = true
		elif event.button_index == 1 and !event.pressed:
			holding_left_click = false
			
		if event.button_index == 2 and event.pressed:
			event.position -= Vector2(minimap_margin,minimap_margin)
			event.position *= Vector2(64,64)
			print(event)
			get_parent().get_parent().get_parent().get_node("Camera").process_move_command(event.position)

			
	if event is InputEventMouseMotion:
		if(holding_left_click):
			if event is InputEventMouseMotion:
				camera.set_camera_target(event.position*Vector2(64,64))
