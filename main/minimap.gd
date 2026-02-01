extends Panel

var minimap_margin = 2
var holding_left_click = false
@onready var camera = get_parent().get_parent().get_parent().get_node("Camera")

func _ready() -> void:
	pass

func _draw():
	#units
	
	for c in get_parent().get_parent().get_parent().get_node("Units").get_children():
		draw_rect(Rect2(c.position.x/64+minimap_margin,c.position.y/64+minimap_margin,2,2),Color.GREEN)
		
	# viewport rectangle
	var resolution = DisplayServer.window_get_size()
	resolution.x /= camera.zoom.x
	resolution.y /= camera.zoom.y
	draw_rect(Rect2(camera.position.x/64-resolution.x/2/64,camera.position.y/64-resolution.y/2/64,resolution.x/64,resolution.y/64),Color.WHITE,false)
	
func _process(delta: float) -> void:
	queue_redraw()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			holding_left_click = true
		elif event.button_index == 1 and !event.pressed:
			holding_left_click = false
			
		if event.button_index == 2 and event.pressed:
			event.position *= Vector2(64,64)
			get_parent().get_parent().get_parent().get_node("Camera").process_move_command(event.position)

			
	if event is InputEventMouseMotion:
		if(holding_left_click):
			if event is InputEventMouseMotion:
				camera.set_camera_target(event.position*Vector2(64,64))
