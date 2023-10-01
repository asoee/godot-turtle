class_name TurtleDrawing
extends Node2D


const TurtleCls = preload("res://addons/turtle/turtle.tscn")
const TurtleHudCls = preload("res://addons/turtle/turtle_hud.tscn")
var started = false
var turtle: Turtle
var turtleHud: TurtleHud
var commandQueue := Array()
var mutex: Mutex
var semaphore: Semaphore
signal queue_complete

const NORTH = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	turtle = TurtleCls.instantiate()
	add_child(turtle)
	turtleHud = TurtleHudCls.instantiate()
	turtleHud.turtle = turtle
	add_child(turtleHud)
	print("Ready: ", turtle)
	
	mutex = Mutex.new()
	semaphore = Semaphore.new()
	var thread = Thread.new()
	thread.start(_main)
	queue_complete.connect(_on_queue_complete)
	
func _main():
	pass
	
	
func forward(distance: float):
	_queue_forward(distance)
	semaphore.wait()

func back(distance: float):
	_queue_forward(-distance)
	semaphore.wait()

func left(angle: float):
	_queue_left(angle)
	semaphore.wait()

func right(angle: float):
	_queue_right(angle)
	semaphore.wait()

func jump(distance: float):
	_queue_jump(distance)
	semaphore.wait()

func set_color(color: Color):
	_queue_set_color(color)
	semaphore.wait()

func set_width(width: float):
	_queue_set_width(width)
	semaphore.wait()

func turn_to(angle: float):
	_queue_turn_to(angle)
	semaphore.wait()
	
func _on_queue_complete():
	semaphore.post()

func _process(delta):
	if !started:
		started = true
	_asyncDraw()
		
		
func _asyncDraw():
	if !commandQueue.is_empty():
		while !commandQueue.is_empty():
			var command : Turtle.TurtleCommand = commandQueue.pop_front()
			command.execute(turtle)
			await turtle.command_complete
		queue_complete.emit()
		

func _queue_forward(distance: float):
	var command = Turtle.MoveCommand.new(distance)
	commandQueue.push_back(command)
	
func _queue_jump(distance: float):
	var command = Turtle.JumpCommand.new(distance)
	commandQueue.push_back(command)
	
func _queue_left(angle: float):
	var command = Turtle.TurnCommand.new(-angle)
	commandQueue.push_back(command)

func _queue_turn_to(angle: float):
	var command = Turtle.TurnToCommand.new(angle)
	commandQueue.push_back(command)

func _queue_right(angle: float):
	var command = Turtle.TurnCommand.new(angle)
	commandQueue.push_back(command)

func _queue_set_color(color: Color):
	var command = Turtle.ColorCommand.new(color)
	commandQueue.push_back(command)

func _queue_set_width(width: float):
	var command = Turtle.WidthCommand.new(width)
	commandQueue.push_back(command)

func rgb_color(red: int, green: int, blue: int) -> Color:
	var color: Color = Color8(red, green, blue)
	return color
