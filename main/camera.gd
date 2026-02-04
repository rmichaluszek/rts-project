extends Camera2D

@export var speed: float = 800.0
@export var zoom_step: float = 0.1
@export var min_zoom: float = 0.2
@export var max_zoom: float = 1.0
@export var drag_speed: float = 1.0
@export var camera_safezone: Vector4 = Vector4(0,0,12800,12800)

const Actions = preload("res://main/actions.gd").Actions

var target_cursor = load("res://assets/textures/target_cursor.png")

var dragging: bool = false
var drag_start: Vector2
var selecting: bool = false
var select_start: Vector2

var current_mouse_action: Dictionary

var select_safezone = 40 # dont have to select exactly center of units, it can be +/- 40 pixels

func _ready() -> void:
	set_process_unhandled_input(true)
	
func _unhandled_input(event):
	# zoom
	if event is InputEventKey:
		var action
		if event.keycode==83 && event.pressed == true: # s
			action = get_parent().get_node("GroupManager").get_avaible_actions()[1]
			get_parent().get_node("GUI/Screen/ActionPanel").set_highlighted(1)
		elif event.keycode==65 && event.pressed == true: # a
			action = get_parent().get_node("GroupManager").get_avaible_actions()[0]
			get_parent().get_node("GUI/Screen/ActionPanel").set_highlighted(0)
		if action:
			
			if(Actions[action]["requiresTarget"]):
				set_mouse_action(Actions[action])
			else:
				set_mouse_action(null)
				get_parent().get_node("GUI/Screen/ActionPanel").remove_all_highlights()
				process_action(Actions[action],get_global_mouse_position())
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			self.zoom = (self.zoom - Vector2(zoom_step, zoom_step)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			self.zoom = (self.zoom + Vector2(zoom_step, zoom_step)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				dragging = true
				drag_start = get_global_mouse_position()
			else:
				dragging = false
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if(current_mouse_action!= {}):
					process_action(current_mouse_action,get_global_mouse_position())
					select_start = Vector2.ZERO
					set_mouse_action(null)
					get_parent().get_node("GUI/Screen/ActionPanel").remove_all_highlights()
				else:
					selecting = true
					select_start = get_global_mouse_position()
			else:
				if select_start != Vector2.ZERO:
					selecting = false
					queue_redraw()
					select(Vector4(select_start.x,select_start.y,get_global_mouse_position().x,get_global_mouse_position().y))
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				set_mouse_action(null)
				get_parent().get_node("GUI/Screen/ActionPanel").remove_all_highlights()
				process_action(Actions["MOVE_AND_ATTACK"],get_global_mouse_position())
				# if clicked on unit or building, move command and try to attack/interact,
			else:
				pass

func set_mouse_action(action):
	if action == null:
		current_mouse_action = {}
		Input.set_custom_mouse_cursor(null)
	else:
		selecting = false
		Input.set_custom_mouse_cursor(target_cursor,Input.CURSOR_ARROW,Vector2(16,16))
		current_mouse_action = action
				
func select(rect:Vector4):
	var array : Array[Node]  = []
	
	# swap if the rect is drawn from right to left / down to bottom
	if rect.x > rect.z: 
		var temp = rect.x
		rect.x = rect.z
		rect.z = temp
	if rect.y > rect.w: 
		var temp = rect.y
		rect.y = rect.w
		rect.w = temp
		
	for u in get_parent().get_node("Units").get_children():
		if u.position.x+select_safezone >= rect.x && u.position.x-select_safezone < rect.z && u.position.y+select_safezone > rect.y && u.position.y-select_safezone< rect.w:
			array.push_back(u)
	get_parent().get_node("GroupManager").set_selected_units(array)

func _draw() -> void:
	if(selecting):
		draw_rect(Rect2(select_start-position,get_global_mouse_position()-select_start),Color(0.255, 0.475, 1.0, 0.439))

func set_camera_target(pos):
	position=pos
	
func process_action(action,pos,unit_ref=null):
	if(action != null):
		if(action==Actions["MOVE_AND_ATTACK"]):
			get_parent().get_node("GroupManager").move_action(pos)
		elif(action==Actions["SET_TARGET"]):
			pass
		elif(action==Actions["RETREAT"]):
			get_parent().get_node("GroupManager").retreat_action(get_parent().my_base_location)
		elif(action==Actions["STOP"]):
			get_parent().get_node("GroupManager").stop_action()
	
	

func _process(delta):
	
	var input_vector = Vector2.ZERO
	
	# keyboard support for moving camera
	
	input_vector.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))/(self.zoom.x/2)
	input_vector.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))/(self.zoom.x/2)
	
	if dragging:
		var mouse_delta = drag_start - get_global_mouse_position()
		self.position += mouse_delta * drag_speed
	else:
		self.position += input_vector * speed * delta
		
	if selecting:
		var select_area = get_global_mouse_position() - select_start
		queue_redraw()

	if self.position.x < camera_safezone.x: self.position.x = camera_safezone.x
	if self.position.y < camera_safezone.y: self.position.y = camera_safezone.y
	if self.position.x > camera_safezone.z: self.position.x = camera_safezone.z
	if self.position.y > camera_safezone.w: self.position.y = camera_safezone.w
