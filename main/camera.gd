extends Camera2D

@export var speed: float = 800.0
@export var zoom_step: float = 0.1
@export var min_zoom: float = 0.2
@export var max_zoom: float = 1.0
@export var drag_speed: float = 1.0
@export var camera_safezone: Vector4 = Vector4(-2000,-2000,2000,2000)


var dragging: bool = false
var drag_start: Vector2



func _input(event):
	# Start drag when left mouse button is pressed
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				dragging = true
				drag_start = get_global_mouse_position()
			else:
				dragging = false

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

	if self.position.x < camera_safezone.x: self.position.x = camera_safezone.x
	if self.position.y < camera_safezone.y: self.position.y = camera_safezone.y
	if self.position.x > camera_safezone.z: self.position.x = camera_safezone.z
	if self.position.y > camera_safezone.w: self.position.y = camera_safezone.w
	
	
	# zoom
	
	if Input.is_action_just_pressed("scroll_down"):
		self.zoom = (self.zoom - Vector2(zoom_step, zoom_step)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	elif Input.is_action_just_pressed("scroll_up"):
		self.zoom = (self.zoom + Vector2(zoom_step, zoom_step)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
