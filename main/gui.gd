extends CanvasLayer

@onready var minimap_gui = $Screen/Minimap
@onready var time_gui = $Screen/Time
@onready var actions_gui = $Screen/ActionPanel
@onready var unit_info_gui = $Screen/UnitInfo
@onready var selection_gui = $Screen/UnitsSelected
@onready var resources_gui = $Screen/Resources

func _ready() -> void:
	pass # Replace with function body.

func display_unit(unit_ref: WeakRef):
	unit_info_gui.show_unit(unit_ref)

func display_units(units_ref_aray: Array[WeakRef]):
	selection_gui.display_units(units_ref_aray)
	
func update_gui():
	minimap_gui.get_node("Units").queue_redraw()

func update_time(time):
	var total_seconds := int(time)
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60
	time_gui.get_node("Label").text = "%02d:%02d" % [minutes, seconds]
	
	
	$Screen/Time/Fps.text = "FPS:"+str(int(Engine.get_frames_per_second()))
	
func update_resources(metal,oil,crystal,metal_income,oil_income,crystal_income):
	resources_gui.get_node("Container/LabelMetal").text = str(floori(metal))
	resources_gui.get_node("Container/LabelMetalIncome").text = "+"+str(metal_income)
	resources_gui.get_node("Container/LabelOil").text = str(floori(oil))
	resources_gui.get_node("Container/LabelOilIncome").text = "+"+str(oil_income)
	resources_gui.get_node("Container/LabelCrystal").text = str(floori(crystal))
	resources_gui.get_node("Container/LabelCrystalIncome").text = "+"+str(crystal_income)

func _process(delta: float) -> void:
	pass
