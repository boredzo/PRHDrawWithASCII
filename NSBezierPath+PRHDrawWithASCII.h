//
//  NSBezierPath+PRHDrawWithASCII.h
//  PRHDrawWithASCII
//
//  Created by Peter Hosey on 2013-09-21.
//  Copyright (c) 2013 Peter Hosey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*Draw shapes in ASCII art.
 *The string should be separated by newlines (\n), but doesn't need to be.
 *The sizePerCharacter: variant will try to figure out where rows are automatically, using /, \, -, and | characters as hints.
 *
 *Currently supported:
 *- Regular triangles (^++, +<+, +>+, +++)
 *- Rectangles/squares (++++)
 *- Circles ((), ⁀()‿)
 *- Ellipses (same as circles)
 *
 *Slashes and (escaped) backslashes are mostly ignored, but may be used as hints for counting rows (particularly by the sizePerCharacter: variant).
 *Letters, whitespace (except line separators), and the six punctuation characters ?!:;., will never be processed.
 *(Of course, since letters are ignored, you'll need to use + for a downward-pointing triangle.)
 *
 *Examples:
 *  ^    ⁀  ()
 * / \  ( )
 *+---+  ‿  ( ̮̑)
 */

@interface NSBezierPath (PRHDrawWithASCII)

+ (instancetype) bezierPathWithShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	sizePerCharacter:(NSSize)sizePerCharacter
	string:(NSString *)string;

+ (instancetype) bezierPathWithShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	shapeSize:(NSSize)size
	string:(NSString *)string;

@end
