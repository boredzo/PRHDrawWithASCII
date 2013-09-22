# Drawing with ASCII art

Have you ever wanted to draw shapes in Cocoa using ASCII art?

NOW YOU CAN!

This simple pair of categories helps you draw the following shapes:

- Rectangles!
- Triangles!
- Even SHAPES WITH NO CORNERS AT ALL!

## So you're in a view…

Just send yourself one of these simple messages:

    [self drawShapeCenteredAtPoint_PRH:centerPoint
    	sizePerCharacter:(NSSize){ 10.0, 10.0 } //or something
    	drawingMode:kCGPathFill
    	string:
    		@"  ^  "
    		@" / \\ "
    		@"+---+"
    ];

	
or:

    [self drawShapeCenteredAtPoint_PRH:centerPoint
    	shapeSize:(NSSize){ 100.0, 100.0 }
    	drawingMode:kCGPathFillStroke
    	lineWidth:3.0
    	string:
    		@" ⁀ "
    		@"( )"
    		@" ‿ "
    ];

You have your choice of size-per-character or size-for-the-whole-shape, and of whether you specify a line width or not. The default is 1, though the no-line-width version is really only for when you want to fill and not stroke.

## So you want a Bézier path…

We've got you covered there, too!

The other category adds two methods. They're basically the same as above, but you only get the choice of how to specify size, since of course you can just set the line width once you have the path.
