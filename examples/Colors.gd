extends TurtleDrawing

func _ready():
	for i in 20:
		var shade = 40 + i*10
		set_color_rgb(shade, shade, shade)
		move_forward(100)
		turn_left(170) 


