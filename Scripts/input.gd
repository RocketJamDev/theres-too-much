extends Node2D

const bus_placeholder_node = preload("res://Scenes/bus_placeholder.tscn")

var place_bus_mode: bool = false
var bus_placeholder

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if(!place_bus_mode):
			$"../Grid".check_carpool(get_global_mouse_position())
	
	if(place_bus_mode):
		if(bus_placeholder == null):
			bus_placeholder = bus_placeholder_node.instantiate()
			add_child(bus_placeholder)
		
		var mouse_position = get_global_mouse_position()
		var hovered_cell = $"../Grid".position_to_grid(mouse_position)
		if(hovered_cell == null):
			bus_placeholder.position = mouse_position
		else:
			bus_placeholder.position = $"../Grid".grid_to_position(hovered_cell)

func _on_bus_button_pressed():
	if(place_bus_mode && bus_placeholder != null):
		bus_placeholder.queue_free()
	place_bus_mode = !place_bus_mode
