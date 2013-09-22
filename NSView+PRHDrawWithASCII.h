//
//  NSView+PRHDrawWithASCII.h
//  PRHDrawWithASCII
//
//  Created by Peter Hosey on 2013-09-21.
//  Copyright (c) 2013 Peter Hosey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//Requires NSBezierPath+PRHDrawWithASCII.h, wherein the string syntax is documented, and NSBezierPath+PRHDrawWithASCII.m, wherein it is implemented.

//These methods create such a path and draw it using the current graphics state (fill/stroke color, line width, shadow, etc.).

@interface NSView (PRHDrawWithASCII)

//These methods, if told to stroke, use a line width of 1.
//They're provided so you don't have to provide a line width if you're not stroking.
- (void) drawShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	sizePerCharacter:(NSSize)sizePerCharacter
	drawingMode:(CGPathDrawingMode)drawingMode
	string:(NSString *)string;
- (void) drawShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	shapeSize:(NSSize)size
	drawingMode:(CGPathDrawingMode)drawingMode
	string:(NSString *)string;

- (void) drawShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	sizePerCharacter:(NSSize)sizePerCharacter
	drawingMode:(CGPathDrawingMode)drawingMode
	lineWidth:(CGFloat)lineWidth
	string:(NSString *)string;
- (void) drawShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	shapeSize:(NSSize)size
	drawingMode:(CGPathDrawingMode)drawingMode
	lineWidth:(CGFloat)lineWidth
	string:(NSString *)string;

@end
