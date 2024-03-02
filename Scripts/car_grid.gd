extends Node2D


var car_grid =Array[Array[car]]

var current_car: car

func _ready() -> void:
	pass # Replace with function body.

	 #Al pulsar on_click_on_grid (en process):
	#- Se llama a position_to_grid para obtener el coche pulsado de la matriz de coches.
	#- Se comprueba si hay un coche guardado en la variable.
	#- Si no hay coche pues se guarda.
	#- Si hay un coche, se comprueba si son casillas contiguas y si coincide el color
		#- Si no coincide: se borra el coche guardado y se da feedback de error.
		#- Si coincide: se borra el coche guardado y se comieza el proceso carpooling eliminando de la matriz de coches el segundo coche.

func on_click_on_grid(world_position: Vector2):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("click"):
		#self.on_click_on_grid()
	pass

#- grid_to_position(pos_grid): pos_world: 
#Le pasas la posición de la grid y te devuelve la posción del mundo del centro de la celda.
func grid_to_position(grid_position:Vector2) -> Vector2:
	return Vector2.ZERO
	
#- position_to_grid(pos_world):
 #Le pasas la posición del mundo y te devuelve la posición de la grid.
func position_to_grid(world_position:Vector2) -> Vector2:
	return Vector2.ZERO
#- spawn_cars(): 
# recorrer la grid, spawnea un coche con un color al azar y le establece la posición.
# Y añade ese coche en la grid de coches (array bidimensional).
func spawn_cars():
	pass
# paint_cars(): obtiene la array de coches y 
# los coloca usando el método grid_to_position().
func paint_cars():
	pass
	
#relocate_cars(array de celdas): 
#recoloca todos los coches que están por encima una celda más abajo. 
#Asegurarse que se hace siempre de abajo a arriba.
func relocate_cars(empty_cells: Array[Vector2]):
	pass
#- carpool(coche1 y coche2): 
	#se encarga de borrar el coche 2, sumar dinero, y llamar al método relocate_cars.
func car_pool(car1: car, car2:car) ->void:
	pass
	
	

