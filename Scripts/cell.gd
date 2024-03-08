class_name Cell

enum cell_entity_type {CAR, BUS, EMPTY}

var entity_id = -1
var entity_type = cell_entity_type.EMPTY;

func clear_cell():
	entity_id = -1
	entity_type = cell_entity_type.EMPTY
	
func duplicate():
	var new_cell = Cell.new()
	new_cell.entity_id = entity_id
	new_cell.entity_type = entity_type
	return new_cell
