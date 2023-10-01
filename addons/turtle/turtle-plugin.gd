@tool
extends EditorPlugin

const TURTLE_TYPE = "Turtle"
const TURTLE_DARWING_TYPE = "TurtleDrawing"


func _enter_tree():
	# Initialization of the plugin goes here
	add_custom_type(TURTLE_TYPE, "Node2D", preload("turtle.gd"), preload("icon.png"))
	add_custom_type(TURTLE_DARWING_TYPE, "Node2D", preload("turtle_drawing.gd"), preload("icon.png"))


func _exit_tree():
	remove_custom_type(TURTLE_DARWING_TYPE)
	remove_custom_type(TURTLE_TYPE)
