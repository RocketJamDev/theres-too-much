extends Node2D


var car_grid =  []
var column_size :int = 6
var row_size :int = 8
var cell_size: int = 20

const green_car = preload("res://Scenes/green_car.tscn")
const blue_car = preload("res://Scenes/blue_car.tscn")
const red_car = preload("res://Scenes/red_car.tscn")

const car_spawn = [green_car, blue_car, red_car]

var current_car: car

func _ready() -> void:
	spawn_cars()
	paint_cars()


	 #Al pulsar on_click_on_grid (en process):
	#- Se llama a position_to_grid para obtener el coche pulsado de la matriz de coches.
	#- Se comprueba si hay un coche guardado en la variable.
	#- Si no hay coche pues se guarda.
	#- Si hay un coche, se comprueba si son casillas contiguas y si coincide el color
		#- Si no coincide: se borra el coche guardado y se da feedback de error.
		#- Si coincide: se borra el coche guardado y se comieza el proceso carpooling eliminando de la matriz de coches el segundo coche.

func on_click_on_grid(world_position: Vector2):
	var grid_position = position_to_grid(world_position)
	print("World position: " + str(world_position) + " is Grid position: " + str(grid_position))
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		self.on_click_on_grid(get_global_mouse_position())
	pass

#- grid_to_position(pos_grid): pos_world: 
#Le pasas la posición de la grid y te devuelve la posción del mundo del centro de la celda.
func grid_to_position(grid_position:Vector2) -> Vector2:
	if(grid_position.x > row_size || grid_position.y > column_size):
		print("grid_to_position: grid_position out of bounds")
		return Vector2.ZERO
	
	var world_position = Vector2()
	world_position.x = grid_position.x * cell_size + cell_size / 2
	world_position.y = grid_position.y * cell_size + cell_size / 2
	return world_position
	return Vector2.ZERO

#- position_to_grid(pos_world):
 #Le pasas la posición del mundo y te devuelve la posición de la grid.
func position_to_grid(world_position:Vector2) -> Vector2:
	var grid_position = Vector2()
	grid_position.x = floor(world_position.x / cell_size)
	grid_position.y = floor(world_position.y / cell_size)
	
	if(grid_position.x > column_size || grid_position.y > row_size):
		print("position_to_grid: grid_position out of bounds")
		return Vector2.ZERO
	return grid_position


#- spawn_cars(): 
# recorrer la grid, spawnea un coche con un color al azar y le establece la posición.
# Y añade ese coche en la grid de coches (array bidimensional).
func spawn_cars():
	for i in range(row_size):
		var row = []
		for j in range(column_size):
			var random_index = randi_range(0,2)
			var car_to_add = car_spawn[random_index].instantiate()
			row.append(car_to_add)
		car_grid.append(row)

# paint_cars(): obtiene la array de coches y 
# los coloca usando el método grid_to_position().
func paint_cars():
	for i in range(row_size):
		for j in range(column_size):
			var car_to_paint = car_grid[i][j]
			car_to_paint.position = grid_to_position(Vector2(i, j))
			print("Pintando coche de color " + str(car_to_paint.color) + " en celda (" + str(i) + ", " + str(j) + ") en posicion " + str(car_to_paint.position))
	
#relocate_cars(array de celdas): 
#recoloca todos los coches que están por encima una celda más abajo. 
#Asegurarse que se hace siempre de abajo a arriba.
func relocate_cars(empty_cells: Array[Vector2]):
	pass
#- carpool(coche1 y coche2): 
	#se encarga de borrar el coche 2, sumar dinero, y llamar al método relocate_cars.
func car_pool(car1: car, car2:car) ->void:
	pass
	
	

