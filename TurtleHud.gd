extends CanvasLayer
class_name TurtleHud

var turtle: Turtle

onready var posLabel = $Position

# Called when the node enters the scene tree for the first time.
func _ready():
	 pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta):
	updateUi()
	handleInput()
	
func updateUi():
	var posText := "Pos: x=%d,y=%d" % [turtle._pivot.position.x, turtle._pivot.position.y]
	posLabel.text = posText
	
func handleInput():
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("pause"):
		togglePause()
	if Input.is_action_just_pressed("toggle_turbo"):
		toggleTurbo()
			
func toggleTurbo():
	if (turtle.speed_multiplier == Turtle.DEFAULT_SPEED):
		turtle.speed_multiplier = Turtle.TURBO_SPEED
	else:
		turtle.speed_multiplier = Turtle.DEFAULT_SPEED

func togglePause():
	get_tree().paused = !get_tree().paused					
