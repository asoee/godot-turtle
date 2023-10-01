extends Turtle

func _main():
	#firkant()
	#right(45)
	#set_color(Color.red)
	#firkant()
	drunk_pirate()
#	colored_squares()
	var color = Color.RED
	

func colored_squares():
	var colors = [Color.RED, Color.ORANGE_RED, Color(0.6, 0.2, 0.7), Color8(248, 86, 243), Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.VIOLET]
	for i in len(colors):
		var color = colors[0]
		set_color(color)
		firkant()
		left(25)

func firkant():
	var side = 50
	for i in 4:
#		side = side + 10
		forward(side)
		right(90)

func drunk_pirate():
	for i in 20:
		forward(20)
		right(randf_range(-45,45))
		
