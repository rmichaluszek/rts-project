extends Panel

var unit_item = null
var current_units_ref_array: Array[WeakRef] = []

func _ready() -> void:
	# things like that should be in singleton resource manager, but the project is so small it doesnt matter
	unit_item = ResourceLoader.load("res://objects/gui/units_selected_item.tscn")

func _process(delta: float) -> void:
	
	if(current_units_ref_array.size() == $ScrollContainer/GridContainer.get_child_count()):
		return
	
	for c in $ScrollContainer/GridContainer.get_children():
		c.queue_free()
	# things like this should be connected to signal emitted when unit dies, so it doesnt check it every frame
	var visible_units = []
	for i in current_units_ref_array:
		if is_instance_valid(i.get_ref()):
			visible_units.push_back(i.get_ref())
			var item = unit_item.instantiate()
			#unit item set texture and weakref so it can be selected from gui
			item.unit_ref = i
			$ScrollContainer/GridContainer.add_child(item)
	
	if visible_units.size()<=0:
		hide_units()
		

func set_highlighted_unit(unit_ref: WeakRef):
	for c in $ScrollContainer/GridContainer.get_children():
		c.set_highlighted(c.unit_ref.get_ref() == unit_ref.get_ref())

func display_units(units_ref_array: Array[WeakRef]):
	if(units_ref_array==[]): 
		hide_units()
		return
	current_units_ref_array = units_ref_array
		
func hide_units():
	current_units_ref_array = []
	
