@icon("res://addons/turtle/icon32.png")
class_name Turtle
extends Node2D

signal queue_complete

const DRAWING_PREFAB = preload("res://addons/turtle/drawing.tscn")
const HUD_PREFAB = preload("res://addons/turtle/turtle_hud.tscn")

var started = false
var drawing: Drawing
var turtleHud: TurtleHud
var commandQueue := Array()
var mutex: Mutex
var semaphore: Semaphore

const NORTH = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	drawing = DRAWING_PREFAB.instantiate()
	add_child.call_deferred(drawing)
	turtleHud = HUD_PREFAB.instantiate()
	turtleHud.drawing = drawing
	add_child.call_deferred(turtleHud)
	
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
			var command : Drawing.TurtleCommand = commandQueue.pop_front()
			command.execute(drawing)
			await drawing.command_complete
		queue_complete.emit()
		

func _queue_forward(distance: float):
	var command = Drawing.MoveCommand.new(distance)
	commandQueue.push_back(command)
	
func _queue_jump(distance: float):
	var command = Drawing.JumpCommand.new(distance)
	commandQueue.push_back(command)
	
func _queue_left(angle: float):
	var command = Drawing.TurnCommand.new(-angle)
	commandQueue.push_back(command)

func _queue_turn_to(angle: float):
	var command = Drawing.TurnToCommand.new(angle)
	commandQueue.push_back(command)

func _queue_right(angle: float):
	var command = Drawing.TurnCommand.new(angle)
	commandQueue.push_back(command)

func _queue_set_color(color: Color):
	var command = Drawing.ColorCommand.new(color)
	commandQueue.push_back(command)

func _queue_set_width(width: float):
	var command = Drawing.WidthCommand.new(width)
	commandQueue.push_back(command)

func rgb_color(red: int, green: int, blue: int) -> Color:
	var color: Color = Color8(red, green, blue)
	return color
