extends CanvasLayer
class_name TurtleHud

var drawing: Drawing

@onready var posLabel = $Position

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	updateUi()
	handleInput()
	
func updateUi():
	var posText := "Pos: x=%d,y=%d" % [drawing._pivot.position.x, drawing._pivot.position.y]
	posLabel.text = posText
	
func handleInput():
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("pause"):
		togglePause()
	if Input.is_action_just_pressed("toggle_turbo"):
		toggleTurbo()
			
func toggleTurbo():
	if (drawing.speed_multiplier == Drawing.DEFAULT_SPEED):
		drawing.speed_multiplier = Drawing.TURBO_SPEED
	else:
		drawing.speed_multiplier = Drawing.DEFAULT_SPEED

func togglePause():
	get_tree().paused = !get_tree().paused					
