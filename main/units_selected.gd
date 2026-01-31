extends Panel

var unit_item = null
var current_units_ref_array: Array[WeakRef] = []

func _ready() -> void:
	# things like that should be in singleton resource manager, but the project is so small it doesnt matter
	unit_item = ResourceLoader.load("res://objects/gui/units_selected_item.tscn")

func _process(delta: float) -> void:
	
	for c in $ScrollContainer/GridContainer.get_children():
		c.queue_free()
	# things like this should be connected to signal emitted when unit dies, so it doesnt check it every frame
	var visible_units = []
	for i in current_units_ref_array:
		if is_instance_valid(i.get_ref()):
			visible_units.push_back(i.get_ref())
	
	if visible_units.size()<=0:
		hide_units()
	for i in visible_units:
		var item = unit_item.instantiate()
		#unit item set texture and weakref so it can be selected from gui
		$ScrollContainer/GridContainer.add_child(item)
	

func display_units(units_ref_array: Array[WeakRef]):
	if(units_ref_array==[]): 
		hide_units()
		return
	current_units_ref_array = units_ref_array
		
func hide_units():
	current_units_ref_array = []
	
