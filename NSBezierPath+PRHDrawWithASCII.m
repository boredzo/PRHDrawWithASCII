//
//  NSBezierPath+PRHDrawWithASCII.m
//  PRHDrawWithASCII
//
//  Created by Peter Hosey on 2013-09-21.
//  Copyright (c) 2013 Peter Hosey. All rights reserved.
//

#import "NSBezierPath+PRHDrawWithASCII.h"

static NSString *const northTriangle = @"^++";
static NSString *const westTriangle = @"+<+";
static NSString *const eastTriangle = @"+>+";
static NSString *const southTriangle = @"+++";
static NSString *const rectangle = @"++++";
static NSString *const circleLeftRightOnly = @"()";
static NSString *const circleOneLine = @"( ̮̑)";
static NSString *const circleTwoLines = @"⁀(‿)";
static NSString *const circleThreeLines = @"⁀()‿";

@interface PRHShapeFromASCIIAnalyzer : NSObject

- (instancetype) initWithString:(NSString *)string;

- (bool) analyze;

- (NSBezierPath *) bezierPathWithCenterPoint:(NSPoint)centerPoint sizePerCharacter:(NSSize)sizePerCharacter;
- (NSBezierPath *) bezierPathWithCenterPoint:(NSPoint)centerPoint size:(NSSize)size;

@property(readonly) NSUInteger numberOfRows, numberOfColumns;
//Corners such as <>+, arcs such as ⁀()‿ .
@property(readonly, copy) NSString *keyCharacters;
//Straight line segments such as / \ | -.
@property(readonly, copy) NSString *northeastLineSegmentCharacters, *southeastLineSegmentCharacters, *verticalLineSegmentCharacters, *horizontalLineSegmentCharacters;

@end

@implementation NSBezierPath (PRHDrawWithASCII)

+ (instancetype) bezierPathWithShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	sizePerCharacter:(NSSize)sizePerCharacter
	string:(NSString *)string
{
	PRHShapeFromASCIIAnalyzer *analyzer = [[PRHShapeFromASCIIAnalyzer alloc] initWithString:string];
	return [analyzer bezierPathWithCenterPoint:centerPoint sizePerCharacter:sizePerCharacter];
}

+ (instancetype) bezierPathWithShapeCenteredAtPoint_PRH:(NSPoint)centerPoint
	shapeSize:(NSSize)size
	string:(NSString *)string
{
	PRHShapeFromASCIIAnalyzer *analyzer = [[PRHShapeFromASCIIAnalyzer alloc] initWithString:string];
	return [analyzer bezierPathWithCenterPoint:centerPoint size:size];
}

@end

@interface PRHShapeFromASCIIAnalyzer ()

@property(readwrite) NSUInteger numberOfRows, numberOfColumns;
@property(readwrite, copy) NSString *keyCharacters;
@property(readwrite, copy) NSString *northeastLineSegmentCharacters, *southeastLineSegmentCharacters, *verticalLineSegmentCharacters, *horizontalLineSegmentCharacters;

- (bool) analyzeByLines;
- (bool) analyzeByKeyCharacters;

@end

@implementation PRHShapeFromASCIIAnalyzer
{
	NSString *_string;
	bool _successfullyAnalyzed;
}

- (instancetype) initWithString:(NSString *)string {
	if ((self = [super init])) {
		_string = [string copy];
	}
	return self;
}

- (bool) analyze {
	if ( ! _successfullyAnalyzed) {
		_successfullyAnalyzed = [self analyzeByLines];
		if ( !_successfullyAnalyzed)
			_successfullyAnalyzed = [self analyzeByKeyCharacters];
	}

	return _successfullyAnalyzed;
}

- (bool) analyzeByLines {
	NSArray *rows = [_string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSUInteger numRows = rows.count;
	NSUInteger numCols;
	if (numRows > 1) {
		//Arguably might be worth being more selective and only looking for distances between key characters/along line segments, at least for polygons.
		//In particular, including a comment in the string could throw off the length we count here. Let's call this a TODO.
		NSNumber *longestRowLength = [rows valueForKeyPath:@"@max.length"];
		numCols = longestRowLength.unsignedIntegerValue;
		if (numCols > 0) {
			self.numberOfColumns = numCols;
			self.numberOfRows = numRows;
			return true;
		}
	}

	return false;
}

- (bool) analyzeByKeyCharacters {
	NSMutableString *keyCharacters = [NSMutableString new];
	NSMutableString *northeastLineSegmentCharacters = [NSMutableString new];
	NSMutableString *southeastLineSegmentCharacters = [NSMutableString new];
	NSMutableString *verticalLineSegmentCharacters = [NSMutableString new];
	NSMutableString *horizontalLineSegmentCharacters = [NSMutableString new];

	NSString *pattern = [@[
		@"[<>^+]",
		@"-+",
		@"\\|+",
		@"\\\\+",
		@"/+",
		@"[()\\u2040\\u203F\\u0311\\u032E]+"
	] componentsJoinedByString:@"|"];
	NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:pattern
		options:0
		error:NULL];
	[exp enumerateMatchesInString:_string options:0 range:(NSRange){ 0, _string.length }
		usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
			NSString *match = [_string substringWithRange:result.range];
			if (match.length > 0) {
				switch ([match characterAtIndex:0]) {
					case '-':
						if (match.length > horizontalLineSegmentCharacters.length)
							[horizontalLineSegmentCharacters setString:match];
						break;
					case '|':
						if (match.length > verticalLineSegmentCharacters.length)
							[verticalLineSegmentCharacters setString:match];
				        break;
					case '\\':
						[southeastLineSegmentCharacters appendString:match];
				        break;
					case '/':
						[northeastLineSegmentCharacters appendString:match];
				        break;
					default:
						[keyCharacters appendString:match];
						break;
				}
			}
		}];

	NSArray *recognizedShapes = @[
		northTriangle,
		westTriangle,
		eastTriangle,
		southTriangle,
		rectangle,
		circleLeftRightOnly,
		circleThreeLines,
		circleTwoLines,
		circleOneLine,
	];
	if ([recognizedShapes containsObject:keyCharacters]) {
		self.keyCharacters = keyCharacters;
		self.northeastLineSegmentCharacters = northeastLineSegmentCharacters;
		self.southeastLineSegmentCharacters = southeastLineSegmentCharacters;
		self.verticalLineSegmentCharacters = verticalLineSegmentCharacters;
		self.horizontalLineSegmentCharacters = horizontalLineSegmentCharacters;

		if (self.verticalLineSegmentCharacters.length > 0)
			self.numberOfRows = self.verticalLineSegmentCharacters.length + 2;
		if (self.horizontalLineSegmentCharacters.length > 0)
			self.numberOfColumns = self.horizontalLineSegmentCharacters.length + 2;

		if (self.numberOfColumns <= 2)
			self.numberOfColumns = self.horizontalLineSegmentCharacters.length + MAX(self.northeastLineSegmentCharacters.length, self.southeastLineSegmentCharacters.length) + 2;
		if (self.numberOfRows <= 2)
			self.numberOfRows = self.verticalLineSegmentCharacters.length + MAX(self.northeastLineSegmentCharacters.length, self.southeastLineSegmentCharacters.length) + 2;
		NSLog(@"Key characters: %@; size in characters: %tu by %tu"
			@"\n-: %@"
			@"\n|: %@"
			@"\n\\: %@"
			@"\n/: %@",
			self.keyCharacters, self.numberOfColumns, self.numberOfRows,
			self.horizontalLineSegmentCharacters,
			self.verticalLineSegmentCharacters,
			self.southeastLineSegmentCharacters,
			self.northeastLineSegmentCharacters
		);

		return true;
	}

	return false;
}

- (NSBezierPath *) bezierPathWithCenterPoint:(NSPoint)centerPoint sizePerCharacter:(NSSize)sizePerCharacter {
	[self analyze];

	NSSize size = {
		sizePerCharacter.width * self.numberOfColumns,
		sizePerCharacter.height * self.numberOfRows,
	};
	return [self bezierPathWithCenterPoint:centerPoint size:size];
}

- (NSBezierPath *) bezierPathWithCenterPoint:(NSPoint)centerPoint size:(NSSize)size {
	[self analyze];

	NSBezierPath *path;
	NSRect rect = { NSZeroPoint, size };

	NSString *keyCharacters = self.keyCharacters;
	if ([keyCharacters isEqualToString:rectangle])
		path = [NSBezierPath bezierPathWithRect:rect];
	else if ([keyCharacters isEqualToString:circleLeftRightOnly] || [keyCharacters isEqualToString:circleOneLine] || [keyCharacters isEqualToString:circleTwoLines] || [keyCharacters isEqualToString:circleThreeLines])
		path = [NSBezierPath bezierPathWithOvalInRect:rect];
	else {
		path = [NSBezierPath bezierPath];
		if ([keyCharacters isEqualToString:northTriangle]) {
			[path moveToPoint:(NSPoint){ NSMinX(rect), NSMinY(rect) }];
			[path lineToPoint:(NSPoint){ NSMaxX(rect), NSMinY(rect) }];
			[path lineToPoint:(NSPoint){ NSMidX(rect), NSMaxY(rect) }];
			[path closePath];
		} else if ([keyCharacters isEqualToString:eastTriangle]) {
			[path moveToPoint:(NSPoint){ NSMinX(rect), NSMinY(rect) }];
			[path lineToPoint:(NSPoint){ NSMaxX(rect), NSMidY(rect) }];
			[path lineToPoint:(NSPoint){ NSMinX(rect), NSMaxY(rect) }];
			[path closePath];
		} else if ([keyCharacters isEqualToString:westTriangle]) {
			[path moveToPoint:(NSPoint){ NSMinX(rect), NSMidY(rect) }];
			[path lineToPoint:(NSPoint){ NSMaxX(rect), NSMinY(rect) }];
			[path lineToPoint:(NSPoint){ NSMaxX(rect), NSMaxY(rect) }];
			[path closePath];
		} else if ([keyCharacters isEqualToString:southTriangle]) {
			[path moveToPoint:(NSPoint){ NSMinX(rect), NSMaxY(rect) }];
			[path lineToPoint:(NSPoint){ NSMidX(rect), NSMinY(rect) }];
			[path lineToPoint:(NSPoint){ NSMaxX(rect), NSMaxY(rect) }];
			[path closePath];
		} else
			path = nil;
	}

	if (path != nil) {
		NSAffineTransform *transform = [NSAffineTransform transform];
		[transform translateXBy:centerPoint.x - size.width / 2.0
		                    yBy:centerPoint.y - size.height / 2.0];
		[path transformUsingAffineTransform:transform];
	}

	return path;
}

@end
