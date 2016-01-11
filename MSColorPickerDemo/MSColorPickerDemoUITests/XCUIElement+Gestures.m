//
// XCUIElement+Gestures.m
//
// Created by Maksym Shcheglov on 2016-01-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import "XCUIElement+Gestures.h"

@implementation XCUIElement (Gestures)

- (void)tapAtPoint:(CGPoint)point1 andDragTo:(CGPoint)point2
{
    XCUICoordinate *start = [[self coordinateWithNormalizedOffset:CGVectorMake(0.0, 0.0)] coordinateWithOffset:CGVectorMake(point1.x, point1.y)];
    XCUICoordinate *finish = [[self coordinateWithNormalizedOffset:CGVectorMake(0.0, 0.0)] coordinateWithOffset:CGVectorMake(point2.x, point2.y)];

    [start pressForDuration:0.01 thenDragToCoordinate:finish];
}

- (void)tapAtPoint:(CGPoint)point
{
    XCUICoordinate *coordinate = [[self coordinateWithNormalizedOffset:CGVectorMake(0.0, 0.0)] coordinateWithOffset:CGVectorMake(point.x, point.y)];

    [coordinate tap];
}

@end
