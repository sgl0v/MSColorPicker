//
// XCUIElement+RGBView.m
//
// Created by Maksym Shcheglov on 2016-01-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import "XCUIElement+RGBView.h"

@implementation XCUIElement (RGBView)

- (XCUIElement *)rgbColorSample
{
    return [[self.otherElements matchingIdentifier:@"color_sample"] element];
}

- (NSArray<XCUIElement *> *)rgbColorComponents
{
    return [[self.otherElements matchingIdentifier:@"color_component_view"] allElementsBoundByIndex];
}

- (NSArray<XCUIElement *> *)rgbSliders
{
    return [[self.otherElements matchingIdentifier:@"color_slider"] allElementsBoundByIndex];
}

- (NSArray<XCUIElement *> *)rgbLabels
{
    return [self.staticTexts allElementsBoundByIndex];
}

@end
