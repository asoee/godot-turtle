@tool
extends EditorPlugin

const TURTLE_TYPE = "Turtle"


func _enter_tree():
	# Initialization of the plugin goes here
	add_custom_type(TURTLE_TYPE, "Node2D", preload("turtle.gd"), preload("icon32.png"))


func _exit_tree():
	remove_custom_type(TURTLE_TYPE)
