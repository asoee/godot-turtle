extends Turtle

func _main():
	for i in 20:
		var shade = 40 + i*10
		set_color(rgb_color(shade, shade, shade))
		forward(100)
		left(170) 


