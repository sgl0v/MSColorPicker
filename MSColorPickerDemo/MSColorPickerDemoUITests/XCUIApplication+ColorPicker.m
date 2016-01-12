//
// XCUIApplication+ColorPicker.m
//
// Created by Maksym Shcheglov on 2016-01-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import "XCUIApplication+ColorPicker.h"

@implementation XCUIApplication (ColorPicker)

- (XCUIElement *)rgbView
{
    XCUIElement *window = [self.windows elementBoundByIndex:0];

    return window.otherElements[@"rgb_view"];
}

- (XCUIElement *)hsbView
{
    XCUIElement *window = [self.windows elementBoundByIndex:0];

    return window.otherElements[@"hsb_view"];
}

- (XCUIElement *)rgbButton
{
    XCUIElement *navigationBar = self.navigationBars[@"MSColorSelectionView"];

    return navigationBar.buttons[@"RGB"];
}

- (XCUIElement *)hsbButton
{
    XCUIElement *navigationBar = self.navigationBars[@"MSColorSelectionView"];

    return navigationBar.buttons[@"HSB"];
}

- (XCUIElement *)doneButton
{
    XCUIElement *navigationBar = self.navigationBars[@"MSColorSelectionView"];

    return navigationBar.buttons[@"Done"];
}

@end
