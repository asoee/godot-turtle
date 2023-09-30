godot-turtle
============
 
This is yet another turtle implementation, but this time for the [godot game engine](godot.com).  
This is of course heavily inspired by the [original LOGO turtle](https://techcommunity.microsoft.com/t5/small-basic-blog/small-basic-the-history-of-the-logo-turtle/ba-p/337073), but also from the excellent [Learn GDScript From Zero](https://github.com/GDQuest/learn-gdscript) from GDQuest.

However, i wanted a version where students were able to do a bit more freestyling in the classroom, and in their actual Godot environment. And thus, this project came to be.

## How to Use

You can simply download this project, and import it into Godot. This will provide a project with a `Main` scene + script, and the turtle implementation hidden away in a `modules` subfolder.

The `Main` script will have a simple `_ready()` function that draws a square.

	extends TurtleDrawing

	func _ready():
		for i in 4:
			move_forward(100)
			turn_left(90)

## Commands

These are the commands that can be used to control the turtle.

| Command                  | Description                                                     |
| ------------------------ | --------------------------------------------------------------- |
| `move_forward(distance)` | Moves the turtle forward the specified distance, while drawing. |
| `turn_left(degrees)`     | Turns the number of degrees left                                |
| `turn_right(degrees)`    | Turns the number of degrees right                               |
| `jump_forward(distance)` | Jumps the distance forward without drawing                      |

## Hotkeys

A few hotkeys can be used while the turtle is drawing

| Key        | Function                  |
| ---------- | ------------------------- |
| Q / Escape | Quit                      |
| P          | Pause/Unpause the drawing |
| T          | Toggle Turbo mode         |

## Technical details

To handle the mismatch between the simple synchronous code that i want the users to write, and the asynchronous nature of the game engine with animations and visual feedback, the turtle code commands simply adds commands objects to a queue, that is then executed one by one afterwards
This means, that you cannot access the coordinates of the turtle directly, since while the user code is executing, the turtle simply have not moved yet.  
For simple programs, i doubt this is going to be an issue.  
Also... dont go overboard with recursion :)

