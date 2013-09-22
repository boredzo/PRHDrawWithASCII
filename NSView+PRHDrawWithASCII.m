//
//  NSView+PRHDrawWithASCII.m
//  PRHDrawWithASCII
//
//  Created by Peter Hosey on 2013-09-21.
//  Copyright (c) 2013 Peter Hosey. All rights reserved.
//

#import "NSView+PRHDrawWithASCII.h"

#import "NSBezierPath+PRHDrawWithASCII.h"

@implementation NSView (PRHDrawWithASCII)

- (void) drawShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	sizePerCharacter:(NSSize)sizePerCharacter
	drawingMode:(CGPathDrawingMode)drawingMode
	string:(NSString *)string
{
	[self drawShapeCenteredAtPoint_PRH:centerPoint
		sizePerCharacter:sizePerCharacter
		drawingMode:drawingMode
		lineWidth:1.0
		string:string];
}

- (void) drawShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	shapeSize:(NSSize)size
	drawingMode:(CGPathDrawingMode)drawingMode
	string:(NSString *)string
{
	[self drawShapeCenteredAtPoint_PRH:centerPoint
		shapeSize:size
		drawingMode:drawingMode
		lineWidth:1.0
		string:string];
}

- (void) drawShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	sizePerCharacter:(NSSize)sizePerCharacter
	drawingMode:(CGPathDrawingMode)drawingMode
	lineWidth:(CGFloat)lineWidth
	string:(NSString *)string
{
	NSBezierPath *path = [NSBezierPath bezierPathWithShapeCenteredAtPoint_PRH:centerPoint
		sizePerCharacter:sizePerCharacter
		string:string];
	path.lineWidth = lineWidth;

	[self drawPath_PRH:path withDrawingMode:drawingMode];
}

- (void) drawShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	shapeSize:(NSSize)size
	drawingMode:(CGPathDrawingMode)drawingMode
	lineWidth:(CGFloat)lineWidth
	string:(NSString *)string
{
	NSBezierPath *path = [NSBezierPath bezierPathWithShapeCenteredAtPoint_PRH:centerPoint
		shapeSize:size
		string:string];
	path.lineWidth = lineWidth;

	[self drawPath_PRH:path withDrawingMode:drawingMode];
}

- (void) drawPath_PRH:(NSBezierPath *)path withDrawingMode:(CGPathDrawingMode)drawingMode {
	switch (drawingMode) {
		case kCGPathEOFill:
		case kCGPathEOFillStroke:
			path.windingRule = NSEvenOddWindingRule;
		case kCGPathFill:
		case kCGPathFillStroke:
			[path fill];
	        break;

		case kCGPathStroke:break;
	}
	switch (drawingMode) {
		case kCGPathEOFillStroke:
		case kCGPathFillStroke:
		case kCGPathStroke:
			[path stroke];
	        break;

		case kCGPathFill:break;
		case kCGPathEOFill:break;
	}
}

@end
