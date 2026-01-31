extends CanvasLayer

@onready var minimap_gui = $Screen/Minimap
@onready var time_gui = $Screen/Time
@onready var actions_gui = $Screen/ActionPanel
@onready var unit_info_gui = $Screen/UnitInfo
@onready var selection_gui = $Screen/UnitsSelected
@onready var resources_gui = $Screen/Resources

func _ready() -> void:
	pass # Replace with function body.


func update_time(time):
	var total_seconds := int(time)
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60
	time_gui.get_node("Label").text = "%02d:%02d" % [minutes, seconds]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
