class_name Drawing
extends Node2D

@onready var _pivot := $Pivot as Node2D
@onready var _sprite := $Pivot/Sprite2D as Sprite2D
@onready var _shadow := $Pivot/Shadow as Sprite2D
@onready var _canvas := $Canvas as Node2D
@onready var _camera := $Camera2D as Camera2D

@onready var screen_size = get_viewport_rect().size

const DEFAULT_LINE_THICKNESS := 2.0
const DEFAULT_COLOR := Color.WHITE
const TURTLE_COMMAND_COMPLETE = "command_complete"

const DEFAULT_SPEED = 1.0
const TURBO_SPEED = 10.0

@export var line_width = DEFAULT_LINE_THICKNESS
@export var color : Color = DEFAULT_COLOR

@export var draw_speed := 100.0
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
	
# Animates the turtle's height and shadow scale when jumping. Tween the progress
# value from 0 to 1.
func _animate_jump(progress: float, distance: float) -> void:
	var parabola := -pow(2.0 * progress - 1.0, 2.0) + 1.0
	_sprite.position.y = -parabola * distance / 2
	var shadow_scale := (1.0 - parabola + 1.0) / 2.0
	_shadow.scale = shadow_scale * Vector2.ONE	
 
	
func signal_command_complete():
	call_deferred( "emit_signal", TURTLE_COMMAND_COMPLETE)
	
class AnimatedLine2D:
	extends Line2D

	var last_point : get = get_last_point, set = set_last_point
	func set_last_point(pos : Vector2):
		points[-1] = pos
	func get_last_point():
		return points[-1]

class TurtleCommand:
	
	func execute(_drawing: Drawing):
		pass

class TurnCommand:
	extends TurtleCommand
	
	var _angle
	
	# Class Constructor
	func _init(angle:float = 0.0):
		_angle = angle
	
	func execute(drawing: Drawing):
		print("Executing: turn: ", _angle )
		var new_rotation = drawing._pivot.rotation_degrees + _angle
		var duration = abs(_angle / drawing.turn_speed_degrees / drawing.speed_multiplier)
		var tw := drawing.create_tween()
		tw.tween_property(
			drawing._pivot,
			"rotation_degrees",
			new_rotation,
			duration
		)
		await tw.finished	
		drawing.signal_command_complete()

class TurnToCommand:
	extends TurtleCommand
	
	var _angle
	
	# Class Constructor
	func _init(angle:float = 0.0):
		_angle = angle
	
	func execute(drawing: Drawing):
		print("Executing: turn to: ", _angle )
		var new_rotation = _angle
		var duration = abs(drawing._pivot.rotation_degrees - _angle / drawing.turn_speed_degrees / drawing.speed_multiplier)
		var tw := drawing.create_tween()
		tw.tween_property(
			drawing._pivot,
			"rotation_degrees",
			new_rotation,
			duration
		)
		await tw.finished	
		drawing.signal_command_complete()

	
class MoveCommand:
	extends TurtleCommand
	
	var _distance
	
	# Class Constructor
	func _init(distance:float = 0):
		_distance = distance
	
	func execute(drawing: Drawing):
		print("Executing: move_forward: ", _distance )
		var move = Vector2.RIGHT * _distance
		move = move.rotated(drawing._pivot.rotation)
		var start_pos = drawing._pivot.position
		var target = start_pos + move
		target = Vector2(snapped(target.x,0.01), snapped(target.y,0.01))
		var draw_start_delay = 0.1
		var duration = start_pos.distance_to(target) / drawing.draw_speed / drawing.speed_multiplier
		print("Move: ", start_pos, " + ", move, " -> ", target)
		var tw := drawing.create_tween() \
			.set_ease(Tween.EASE_IN) \
			.set_trans(Tween.TRANS_LINEAR)
			
		tw.tween_property(
			drawing._pivot,
			"position",
			target,
			duration
		)
		
		var line = AnimatedLine2D.new()
		line.width = drawing.line_width
		line.default_color = drawing.color
		
		line.add_point(start_pos)
		line.add_point(start_pos)
		drawing._canvas.add_child(line)

		tw.parallel().tween_property(
			line,
			"last_point",
			target,
			duration).from_current()
		await tw.finished
		drawing.signal_command_complete()
		
class JumpCommand:
	extends TurtleCommand
	
	var _distance
	
	# Class Constructor
	func _init(distance:float = 0):
		_distance = distance
	
	func execute(drawing: Drawing):
		print("Executing: move_forward: ", _distance )
		var move = Vector2.RIGHT * _distance
		move = move.rotated(drawing._pivot.rotation)
		var start_pos = drawing._pivot.position
		var target = start_pos + move
		target = Vector2(snapped(target.x,0.01), snapped(target.y,0.01))
		var draw_start_delay = 0.1
		var duration = 2 * start_pos.distance_to(target) / drawing.draw_speed / drawing.speed_multiplier
		print("Move: ", start_pos, " + ", move, " -> ", target)
		var tw := drawing.create_tween() \
			.set_parallel(true) \
			.set_ease(Tween.EASE_IN) \
			.set_trans(Tween.TRANS_LINEAR)
			
		tw.tween_property(
			drawing._pivot,
			"position",
			target,
			duration
		)
		
		tw.tween_method(
			drawing._animate_jump,
			0.0,
			1.0,
			duration)
			
		await tw.finished
		drawing.signal_command_complete()

class ColorCommand:
	extends TurtleCommand
	
	var _color
	
	# Class Constructor
	func _init(color:Color = Color.WHITE):
		_color = color
	
	func execute(drawing: Drawing):
		drawing.color = _color
		drawing.signal_command_complete()

class WidthCommand:
	extends TurtleCommand
	
	var _width
	
	# Class Constructor
	func _init(width:float = 4):
		_width = width
	
	func execute(drawing: Drawing):
		drawing.line_width = _width
		drawing.signal_command_complete()
