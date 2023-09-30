extends TurtleDrawing


func main():
	print("main")

func _ready():
	super._ready()
	#firkant()
	#turn_right(45)
	#set_color(Color.red)
	#firkant()
##	drunk_pirate()
	colored_squares()
	var color = Color.RED
	

func colored_squares():
	var colors = [Color.RED, Color.ORANGE_RED, Color(0.6, 0.2, 0.7), Color8(248, 86, 243), Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.VIOLET]
	for i in len(colors):
		var color = colors[0]
		set_color(color)
		firkant()
		turn_left(25)

func firkant():
	var side = 50
	for i in 4:
#		side = side + 10
		move_forward(side)
		turn_right(90)

func drunk_pirate():
	for i in 20:
		move_forward(20)
		turn_right(randf_range(-45,45))
