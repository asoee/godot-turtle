extends Node2D

class_name TurtleDrawing

const TurtleCls = preload("res://modules/turtle/Turtle.tscn")
var started = false
var turtle
var commandQueue := Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	turtle = TurtleCls.instance()
	add_child(turtle)

func _process(delta):
	if (!started):
		started = true
		startDrawing()
		
func startDrawing():
	turtle.reset()
#	draw()
	yield(get_tree().create_timer(1.0), "timeout")
	asyncDraw()

		
func asyncDraw():
	while !commandQueue.empty():
		var command : Turtle.TurtleCommand = commandQueue.pop_front()
		command.execute(turtle)
		yield(turtle, Turtle.TURTLE_COMMAND_COMPLETE)

func move_forward(distance: float):
	var command = Turtle.MoveCommand.new(distance)
	commandQueue.push_back(command)
	
func jump_forward(distance: float):
	var command = Turtle.JumpCommand.new(distance)
	commandQueue.push_back(command)
	
func turn_left(angle: float):
	var command = Turtle.TurnCommand.new(-angle)
	commandQueue.push_back(command)

func turn_right(angle: float):
	var command = Turtle.TurnCommand.new(angle)
	commandQueue.push_back(command)
