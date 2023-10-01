godot-turtle
============
 
This is yet another turtle implementation, but this time for the [godot game engine](godot.com).  
This is of course heavily inspired by the 
[original LOGO turtle](https://techcommunity.microsoft.com/t5/small-basic-blog/small-basic-the-history-of-the-logo-turtle/ba-p/337073), 
but also from the excellent [Learn GDScript From Zero](https://github.com/GDQuest/learn-gdscript) from GDQuest.

However, i wanted a version where students were able to do a bit more freestyling in the classroom, 
and in their actual Godot environment. And thus, this project came to be.

## How to Use

You can simply download this project, and import it into Godot. This will provide a project with a `Main` scene + script, and the turtle implementation hidden away in a `addons/turtle` subfolder.

The `Main` script will have a simple `_main()` function that draws a square.

	extends Turtle

	func _main():
		for i in 4:
			forward(100)
			left(90)

Soon, this will hopefully also be found in the godot asset store.

## Commands

These are the commands that can be used to control the turtle.

| Command                  | Description                                                        |
| ------------------------ | -------------------------------------------------------------------|
| `forward(distance)`      | Moves the turtle forward the specified distance, while drawing.    |
| `left(degrees)`          | Turns the number of degrees left                                   |
| `right(degrees)`         | Turns the number of degrees right                                  |
| `turn_to(degrees)`       | Turns to the specified angle, where 0 is pointing to the right     |
| `jump(distance)`         | Jumps the distance forward without drawing                         |
| `set_color(color)`       | Changes the drawing color, example: Color.RED, or rgb_color(r,g,b) |
| `set_width(width)`       | Changes the drawing width in pixels. Default is 4                  |

## Hotkeys

A few hotkeys can be used while the turtle is drawing

| Key        | Function                  |
| ---------- | ------------------------- |
| Q / Escape | Quit                      |
| P          | Pause/Unpause the drawing |
| T          | Toggle Turbo mode         |

## Technical details

To handle the mismatch between the simple synchronous code that i want the users to write, 
and the asynchronous nature of the game engine with animations and visual feedback, 
the turtle code commands runs in a separate thread, and is simply blocked while the animation of the 
drawing is processed.
