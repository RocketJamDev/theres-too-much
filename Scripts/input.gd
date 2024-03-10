extends Node2D

const bus_placeholder_node = preload("res://Scenes/bus_placeholder.tscn")

var place_bus_mode: bool = false
var bus_placeholder

func _process(delta: float) -> void:
	if(place_bus_mode):
		# Estamos en bus mode
		
		# Creamos el nodo para el placeholder si no existía
		if(bus_placeholder == null):
			bus_placeholder = bus_placeholder_node.instantiate()
			add_child(bus_placeholder)
		
		# Obtenemos la celda en la que esta el cursor.
		var mouse_position = get_global_mouse_position()
		var hovered_cell = $"../Grid".world_to_grid(mouse_position)
		
		if($"../Grid".can_spawn_bus(hovered_cell)):
			# El bus se puede poner
			
			# Snappeamos el placeholder a la celda en la que está el cursor
			bus_placeholder.position = $"../Grid".grid_to_world(hovered_cell)
			
			# Gestionamos el click
			if(Input.is_action_just_pressed("click")):
				# Colocamos el bus
				$"../Grid".spawn_bus(hovered_cell)
		else:
			# El bus no se puede poner.
			
			bus_placeholder.position = mouse_position
	else:
		# No estamos en bus mode
		
		# Gestionamos el click
		if Input.is_action_just_pressed("click"):
			# Iniciamos el proceso de carpool.
			$"../Grid".check_carpool(get_global_mouse_position())
		
func _on_bus_button_pressed():
	if(place_bus_mode && bus_placeholder != null):
		bus_placeholder.queue_free()
	place_bus_mode = !place_bus_mode
