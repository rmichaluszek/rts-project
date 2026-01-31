extends Panel

var currentUnitDisplayedRef: WeakRef = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_unit()

func show_unit(unit_ref: WeakRef):
	if unit_ref==null:
		hide_unit()
		return
	if(is_instance_valid(unit_ref)):
		
		for c in get_children():
			c.visible = true
		currentUnitDisplayedRef = unit_ref
		$DamageAmountLabel.text = str(int(unit_ref.get_ref().damage))
		$RangeAmountLabel.text = str(int(unit_ref.get_ref().range))
		$SpeedAmountLabel.text = str(int(unit_ref.get_ref().movement_speed))
		$NameLabel.text = unit_ref.get_ref().unit_name
		
func _process(delta: float) -> void:
	if(is_instance_valid(currentUnitDisplayedRef)):
		$HealthAmountLabel.text = str(int(currentUnitDisplayedRef.get_ref().health))
	else: # unit is probably dead, stop displaying it
		hide_unit()

func hide_unit():
	for c in get_children():
		c.visible = false
