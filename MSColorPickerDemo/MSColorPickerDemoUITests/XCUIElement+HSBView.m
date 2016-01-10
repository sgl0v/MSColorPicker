//
// XCUIElement+HSBView.m
//
// Created by Maksym Shcheglov on 2016-01-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import "XCUIElement+HSBView.h"

@implementation XCUIElement (HSBView)

- (XCUIElement *)hsbColorSample
{
    return [[self.otherElements matchingIdentifier:@"color_sample"] element];
}

- (XCUIElement *)hsbColorWheel
{
    return [[self.otherElements matchingIdentifier:@"color_wheel_view"] element];
}

- (NSArray<XCUIElement *> *)hsbColorComponents
{
    return [[self.otherElements matchingIdentifier:@"color_component_view"] allElementsBoundByIndex];
}

@end
