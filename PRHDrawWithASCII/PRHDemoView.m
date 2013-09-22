//
//  PRHDemoView.m
//  PRHDrawWithASCII
//
//  Created by Peter Hosey on 2013-09-21.
//  Copyright (c) 2013 Peter Hosey. All rights reserved.
//

#import "PRHDemoView.h"

#import "NSView+PRHDrawWithASCII.h"
#import "NSBezierPath+PRHDrawWithASCII.h"

@implementation PRHDemoView

- (id) initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code here.
	}

	return self;
}


- (void) drawRect:(NSRect)dirtyRect {
	NSRect bounds = self.bounds;

	NSGraphicsContext *context = [NSGraphicsContext currentContext];

	NSRect frameRect = NSInsetRect(bounds, 1.0, 1.0);
	NSColor *frameColor = [NSColor colorWithCalibratedHue:210.0/360.0 saturation:1.0
	                                           brightness:1.0 alpha:1.0];

	[[frameColor colorWithAlphaComponent:0.25] setFill];
	[frameColor setStroke];
	[self drawShapeCenteredAtPoint_PRH:(NSPoint){ NSMidX(bounds), NSMidY(bounds) }
		shapeSize:frameRect.size
		drawingMode:kCGPathFillStroke
		lineWidth:2.0
		string:
			@"+---+"
			@"|   |"
			@"+---+"
	];

	NSSize sizeForCell = [self oneNinthOfBounds];

	NSBezierPath *path = [NSBezierPath bezierPathWithShapeCenteredAtPoint_PRH:(NSPoint){ NSMidX(bounds), NSMidY(bounds)}
		//TODO: Get circles working with sizePerCharacter:. (The measurement code currently doesn't know what to do with circles.)
		shapeSize:sizeForCell
		string:
			@" \u2040 "
			@"( )"
			@" \u203F "
	];
	path.lineWidth = 3.0;

	//Here's the easy way.
	[[NSColor grayColor] setFill];
	[context saveGraphicsState];
	{
		NSShadow *shadow = [NSShadow new];
		shadow.shadowColor = [NSColor whiteColor];
		shadow.shadowBlurRadius = 3.0;
		shadow.shadowOffset = (NSSize){ +5.0, -5.0 };
		[shadow set];

		[path fill];
	}
	[context restoreGraphicsState];
	[[NSColor blackColor] setStroke];
	[path stroke];

	NSSize sizePerCharacter = { 10.0, 10.0 };
	[self drawShapeCenteredAtPoint_PRH:(NSPoint){ NSMinX(bounds) + sizeForCell.width / 2.0, NSMidY(bounds) }
		sizePerCharacter:sizePerCharacter
		drawingMode:kCGPathFillStroke
		string:
			@"    +"
			@"  / |"
			@"<   |"
			@"  \\ |"
			@"    +"
	];

	sizePerCharacter = (NSSize){ 10.0, 30.0 };
	[self drawShapeCenteredAtPoint_PRH:(NSPoint){ NSMidX(bounds), NSMaxY(bounds) - sizeForCell.width / 2.0 }
		sizePerCharacter:sizePerCharacter
		drawingMode:kCGPathFillStroke
		string:
			@"  ^  "
			@" / \\ "
			@"+---+"
	];

	sizePerCharacter = (NSSize){ 20.0, 30.0 };
	[self drawShapeCenteredAtPoint_PRH:(NSPoint){ NSMaxX(bounds) - sizeForCell.width / 2.0, NSMidY(bounds) }
		sizePerCharacter:sizePerCharacter
		drawingMode:kCGPathFillStroke
		string:
			@"+    "
			@"| \\  "
			@"|   >"
			@"| /  "
			@"+    "
	];

	sizePerCharacter = (NSSize){ 30.0, 10.0 };
	[self drawShapeCenteredAtPoint_PRH:(NSPoint){ NSMidX(bounds), NSMinY(bounds) + sizeForCell.width / 2.0 }
		sizePerCharacter:sizePerCharacter
		drawingMode:kCGPathFillStroke
		string:
			@"+---+"
			@" \\ / "
			@"  +  "
	];}

- (NSSize) oneNinthOfBounds {
	NSSize result = self.bounds.size;
	result.width /= 3.0;
	result.height /= 3.0;

	if (result.width < result.height)
		result.height = result.width;
	else if (result.height < result.width)
		result.width = result.height;

	return result;
}

@end
