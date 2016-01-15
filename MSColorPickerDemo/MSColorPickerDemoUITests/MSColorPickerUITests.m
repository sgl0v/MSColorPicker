//
// MSColorPickerUITests.m
//
// Created by Maksym Shcheglov on 2016-01-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <XCTest/XCTest.h>
#import "XCUIApplication+ColorPicker.h"
#import "XCUIElement+RGBView.h"
#import "XCUIElement+HSBView.h"
#import "XCUIElement+Gestures.h"

static const CGFloat MSSliderViewThumbRadius = 14.0f;

@interface MSColorPickerUITests : XCTestCase
@property (nonatomic) XCUIApplication *app;
@end

@implementation MSColorPickerUITests

- (void)setUp
{
    [super setUp];

    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
    [self.app.buttons[@"Set color programmatically"] tap];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUIElementsPresence
{
    XCUIElement *rgbView = self.app.rgbView;

    XCTAssertTrue([rgbView exists]);
    XCTAssertTrue([rgbView.rgbColorSample exists]);
    XCTAssertEqual(rgbView.rgbLabels.count, 3);
    XCTAssertEqual(rgbView.rgbSliders.count, 3);
    XCTAssertEqual(rgbView.rgbColorComponents.count, 3);

    [self.app.hsbButton tap];
    XCUIElement *hsbView = self.app.hsbView;

    XCTAssertTrue([hsbView exists]);
    XCTAssertTrue([hsbView.hsbColorSample exists]);
    XCTAssertTrue([hsbView.hsbColorWheel exists]);
    XCTAssertEqual([hsbView.hsbColorComponents count], 1);
}

- (void)testRGBColorSelectionFlow
{
    XCUIElement *rgbView = self.app.rgbView;

    XCTAssertEqualObjects(rgbView.rgbColorSample.value, @"#FFFFFFFF");

    // 1. Change the red value and verify
    {
        XCUIElement *redSlider = rgbView.rgbSliders[0];
        CGPoint start = (CGPoint) {CGRectGetWidth(redSlider.frame) - MSSliderViewThumbRadius, CGRectGetHeight(redSlider.frame) / 2 };
        CGPoint finish = (CGPoint) {0, CGRectGetHeight(redSlider.frame) / 2 };
        [redSlider tapAtPoint:start andDragTo:finish];
        XCTAssertEqualObjects(rgbView.rgbColorSample.value, @"#00FFFFFF");
    }

    // 2. Change the green value and verify
    {
        XCUIElement *greenSlider = rgbView.rgbSliders[1];
        CGPoint start = (CGPoint) {CGRectGetWidth(greenSlider.frame) - MSSliderViewThumbRadius, CGRectGetHeight(greenSlider.frame) / 2 };
        CGPoint finish = (CGPoint) {0, CGRectGetHeight(greenSlider.frame) / 2 };
        [greenSlider tapAtPoint:start andDragTo:finish];
        XCTAssertEqualObjects(rgbView.rgbColorSample.value, @"#0000FFFF");
    }

    // 3. Change the blue value and verify
    {
        XCUIElement *blueSlider = rgbView.rgbSliders[2];
        CGPoint start = (CGPoint) {CGRectGetWidth(blueSlider.frame) - MSSliderViewThumbRadius, CGRectGetHeight(blueSlider.frame) / 2 };
        CGPoint finish = (CGPoint) {0, CGRectGetHeight(blueSlider.frame) / 2 };
        [blueSlider tapAtPoint:start andDragTo:finish];
        XCTAssertEqualObjects(rgbView.rgbColorSample.value, @"#000000FF");
    }
}

- (void)testColorSelectionFlow
{
    XCUIElement *rgbView = self.app.rgbView;
    NSString *value1 = rgbView.rgbColorSample.value;

    // 1. Change the red value
    XCUIElement *redSlider = rgbView.rgbSliders[0];
    CGPoint start = (CGPoint) {CGRectGetWidth(redSlider.frame) - MSSliderViewThumbRadius, CGRectGetHeight(redSlider.frame) / 2 };
    CGPoint finish = (CGPoint) {CGRectGetWidth(redSlider.frame) / 2, CGRectGetHeight(redSlider.frame) / 2 };

    [redSlider tapAtPoint:start andDragTo:finish];
    NSString *value2 = rgbView.rgbColorSample.value;

    // 2. Check that it is not equal to the prev one
    XCTAssertNotEqualObjects(value1, value2);

    // 3. Go to the hsb view
    [self.app.hsbButton tap];

    // 4. Change the color view color wheel
    XCUIElement *hsbView = self.app.hsbView;
    XCUIElement *colorWheel = hsbView.hsbColorWheel;
    [[colorWheel coordinateWithNormalizedOffset:CGVectorMake(0.9, 0.5)] tap];
    NSString *value3 = hsbView.rgbColorSample.value;

    // 5. Check that it is not equal to the prev one
    XCTAssertNotEqualObjects(value2, value3);

    // 6. Go the to RGB view
    [self.app.rgbButton tap];
    NSString *value4 = rgbView.rgbColorSample.value;

    // 7. Check that HSB and RGB colors are equal
    XCTAssertEqualObjects(value3, value4);

    // 8. End
    [self.app.doneButton tap];
}

@end
