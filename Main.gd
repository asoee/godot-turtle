extends TurtleDrawing

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 50:
		move_forward(i*4)
		turn(100)


