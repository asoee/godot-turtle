extends TurtleDrawing

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 50:
		move_forward(20)
		turn_left(90)
		move_forward(20)
		turn_right(90)
		jump_forward(30)
		turn_left(90)
		jump_forward(130)

	
func spiral():
	for i in 50:
		move_forward(i*5)
		turn_left(120)
	

