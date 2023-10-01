extends Turtle

func _main():
	colored_squares()
	var color = Color.RED
	

func colored_squares():
	var colors = [Color.RED, Color.ORANGE_RED, Color(0.6, 0.2, 0.7), Color8(248, 86, 243), Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.VIOLET]
	for i in len(colors):
		var color = colors[i]
		set_color(color)
		set_width(i + 1)
		square()
		left(360/len(colors))

func square():
	var side = 50
	for i in 4:
#		side = side + 10
		forward(side)
		right(90)
