const Actions = {
	"MOVE_AND_ATTACK": {
		"name":"Move and Attack",
		"requiresTarget": true
	},
	"STOP": {
		"name":"Stop current movement",
		"requiresTarget":false
	},
	"CHASE": {
		"name":"Move to a target unit",
		"requiresTarget": true,
	},
	"SET_TARGET": {
		"name":"Set target to attack",
		"requiresTarget": true
	},
	"ATTACK_ON_SIGHT": {
		"name":"Fire at will",
		"off_name": "Hold fire",
		"requiresTarget": false
	},
	"RETREAT": {
		"name":"Retreat!",
		"requiresTarget": false
	},
}
