class_name Turtle
extends Node2D

onready var _pivot := $Pivot as Node2D
onready var _sprite := $Pivot/Sprite as Sprite
onready var _shadow := $Pivot/Shadow as Sprite
onready var _canvas := $Canvas as Node2D
onready var _camera := $Camera2D as Camera2D

onready var screen_size = get_viewport_rect().size

const DEFAULT_LINE_THICKNESS := 2.0
const DEFAULT_COLOR := Color.white
const TURTLE_COMMAND_COMPLETE = "command_complete"

export var line_width = DEFAULT_LINE_THICKNESS
export var color : Color = DEFAULT_COLOR

export var draw_speed := 400.0
var turn_speed_degrees := 260.0
# Increases the animation playback speed.
var speed_multiplier := 1.0


signal command_complete


func reset():
	_pivot.position = screen_size / 2
	_pivot.rotation = -PI/2

#func draw():
#	for i in 50:
#		move_forward(i*4)
#		turn(90)
	
 
	
func signal_command_complete():
	emit_signal(TURTLE_COMMAND_COMPLETE)

class AnimatedLine2D:
	extends Line2D

	var last_point setget set_last_point, get_last_point
	func set_last_point(pos : Vector2):
		points[-1] = pos
	func get_last_point():
		return points[-1]

class TurtleCommand:
	
	func execute(turtle: Turtle):
		pass

class TurnCommand:
	extends TurtleCommand
	
	var _angle
	
	# Class Constructor
	func _init(angle:float = 0.0):
		_angle = angle
	
	func execute(turtle: Turtle):
		var new_rotation = turtle._pivot.rotation_degrees + _angle
		var duration = _angle / turtle.turn_speed_degrees
		var tw := turtle.create_tween()
		tw.tween_property(
			turtle._pivot,
			"rotation_degrees",
			new_rotation,
			duration
		)
		yield(tw, "finished")	
		turtle.signal_command_complete()
	
class MoveCommand:
	extends TurtleCommand
	
	var _distance
	
	# Class Constructor
	func _init(distance:float = 0):
		_distance = distance
	
	func execute(turtle: Turtle):
		print("Executing: move_forward: ", _distance )
		var move = Vector2.RIGHT * _distance
		move = move.rotated(turtle._pivot.rotation)
		var start_pos = turtle._pivot.position
		var target = start_pos + move
		target = Vector2(stepify(target.x,0.01), stepify(target.y,0.01))
		var draw_start_delay = 0.1
		var duration = start_pos.distance_to(target) / turtle.draw_speed / turtle.speed_multiplier
		print("Move: ", start_pos, " + ", move, " -> ", target)
		var tw := turtle.create_tween() \
			.set_ease(Tween.EASE_IN) \
			.set_trans(Tween.TRANS_LINEAR)
			
		tw.tween_property(
			turtle._pivot,
			"position",
			target,
			duration
		)
		
		var line = AnimatedLine2D.new()
		line.width = turtle.line_width
		line.default_color = turtle.color
		
		line.add_point(start_pos)
		line.add_point(start_pos)
		turtle._canvas.add_child(line)

		tw.parallel().tween_property(
			line,
			"last_point",
			target,
			duration).from_current()
		yield(tw, "finished")
		turtle.signal_command_complete()
