extends Node2D

var car_grid =  []
var column_size :int = 6
var row_size :int = 8
var cell_size: int = 100
var money: int = 0

const green_car = preload("res://Scenes/green_car.tscn")
const blue_car = preload("res://Scenes/blue_car.tscn")
const red_car = preload("res://Scenes/red_car.tscn")

const car_spawn = [green_car, blue_car, red_car]

var current_car: car
var bus_mode: bool = false

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

func check_carpool(world_position: Vector2) -> bool:
	var grid_position = position_to_grid(world_position)
	
	if(grid_position == null):
		current_car = null;
		print('Clicked out of bounds')
		return false
	
	var clicked_car = car_grid[grid_position.y][grid_position.x]
	
	clicked_car = instance_from_id(car_grid[grid_position.y][grid_position.x].entity_id)
	
	if(clicked_car == null):
		print('Clicked in an empty cell')
		current_car = null;
		return false
	
	if(current_car == null):
		print('Car in position (' + str(grid_position.y) + ', ' + str(grid_position.x) + ')' + ' with color ' + str(clicked_car.color) + ' saved.');
		current_car = clicked_car
		return false
	else:
		var clicked_car_grid_position = grid_position
		var current_car_grid_position = position_to_grid(current_car.position)
		
		if(are_positions_contiguous(clicked_car_grid_position, current_car_grid_position) == false):
			current_car = null;
			print('Cars are not contiguous')
			return false
		
		if(current_car.color != clicked_car.color):
			current_car = null;
			print('Cars are not of the same color')
			return false
		
		current_car = null;
		self.carpool(current_car_grid_position, clicked_car_grid_position);
		return true

func are_positions_contiguous(pos1: Vector2, pos2: Vector2) -> bool:
	if abs(pos1.x - pos2.x) <= 1 and abs(pos1.y - pos2.y) <= 1:
		return true
	else:
		return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if(!bus_mode):
			self.check_carpool(get_global_mouse_position())	
		else:
			print("bus mode click")

#- grid_to_position(pos_grid): pos_world: 
#Le pasas la posición de la grid y te devuelve la posción del mundo del centro de la celda.
func grid_to_position(grid_position:Vector2):
	if(grid_position.x >= column_size || grid_position.y >= row_size):
		print("grid_to_position: grid_position out of bounds")
		return null
	
	var world_position = Vector2()
	world_position.x = grid_position.x * cell_size + cell_size / 2
	world_position.y = grid_position.y * cell_size + cell_size / 2
	return world_position

#- position_to_grid(pos_world):
 #Le pasas la posición del mundo y te devuelve la posición de la grid.
func position_to_grid(world_position:Vector2):
	var grid_position = Vector2()
	grid_position.y = floor(world_position.y / cell_size)
	grid_position.x = floor(world_position.x / cell_size)
	
	if(grid_position.x >= column_size || grid_position.y >= row_size):
		print("position_to_grid: grid_position out of bounds")
		return null
	return grid_position

#- spawn_cars(): 
# recorrer la grid, spawnea un coche con un color al azar y le establece la posición.
# Y añade ese coche en la grid de coches (array bidimensional).
func spawn_cars():
	for i in range(row_size):
		var row = []
		for j in range(column_size):
			# creamos el coche
			var random_index = randi_range(0,2)
			var car_to_add = car_spawn[random_index].instantiate()
			
			# creamos la celda
			var cell = Cell.new()
			cell.entity_id = car_to_add.get_instance_id()
			cell.entity_type = Cell.cell_entity_type.CAR
			
			row.append(cell)
		car_grid.append(row)

# paint_cars(): obtiene la array de coches y 
# los coloca usando el método grid_to_position().
func paint_cars():
	for i in range(row_size):
		for j in range(column_size):
			if car_grid[i][j] != null:
				if(car_grid[i][j].entity_type == Cell.cell_entity_type.EMPTY):
					continue
				var car_to_paint = instance_from_id(car_grid[i][j].entity_id)
				car_to_paint.position = grid_to_position(Vector2(j, i))
				add_child(car_to_paint)
				#print("Pintando coche de color " + str(car_to_paint.color) + " en celda (" + str(i) + ", " + str(j) + ") en posicion " + str(car_to_paint.position))

	
#relocate_cars(array de celdas): 
#recoloca todos los coches que están por encima una celda más abajo. 
#Asegurarse que se hace siempre de abajo a arriba.
func relocate_cars(empty_columns: Array[int]):
	# el vector x=i y=j en principio
	print(empty_columns)
	var movable_cars_cell = []
	for column in empty_columns:
		for row in range(row_size-1, -1, -1):
			if(car_grid[row][column].entity_type != Cell.cell_entity_type.EMPTY):
				# guardamos una copia de la celda vieja
				movable_cars_cell.append(car_grid[row][column].duplicate())
				
				# vaciamos la celda 
				car_grid[row][column].clear_cell()
		var row = row_size-1
		for car_cell in movable_cars_cell:
			car_grid[row][column] = car_cell
			row -= 1

#- carpool(coche1 y coche2): 
	#se encarga de borrar el coche 2, sumar dinero, y llamar al método relocate_cars.

# Se elimina de la matriz de coches el segundo coche.
func carpool(car1_grid_position: Vector2, car2_grid_position: Vector2):
	if(car_grid[car2_grid_position.y][car2_grid_position.x] != null):
		instance_from_id(car_grid[car2_grid_position.y][car2_grid_position.x].entity_id).queue_free();
		car_grid[car2_grid_position.y][car2_grid_position.x].clear_cell();
		money += 10;
		print('Carpool successful. Current money: ' + str(money));
		relocate_cars([car2_grid_position.x])
		paint_cars()
	else:
		print('Carpool error car2 not in grid')


func _on_texture_button_pressed():
	bus_mode = !bus_mode
	pass # Replace with function body.
