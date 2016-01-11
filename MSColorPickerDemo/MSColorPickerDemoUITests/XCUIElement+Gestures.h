//
// XCUIElement+Gestures.h
//
// Created by Maksym Shcheglov on 2016-01-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <XCTest/XCTest.h>

@interface XCUIElement (Gestures)

- (void)tapAtPoint:(CGPoint)point1 andDragTo:(CGPoint)point2;
- (void)tapAtPoint:(CGPoint)point;

@end
