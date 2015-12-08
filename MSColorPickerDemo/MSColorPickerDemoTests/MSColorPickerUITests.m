//
// MSColorPickerUITests.m
//
// Created by Maksym Shcheglov on 2016-01-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <XCTest/XCTest.h>

@interface MSColorPickerUITests : XCTestCase

@end

@implementation MSColorPickerUITests

- (void)setUp
{
    [super setUp];

    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    XCUIApplication *app = [[XCUIApplication alloc] init];

    [app.buttons[@"Set color programmatically"] tap];

    XCUIElement *element = [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [element tap];

    XCUIElement *mscolorselectionviewNavigationBar2 = app.navigationBars[@"MSColorSelectionView"];
    XCUIElement *mscolorselectionviewNavigationBar = mscolorselectionviewNavigationBar2;
    [mscolorselectionviewNavigationBar.buttons[@"HSB"] tap];
    [element tap];
    [mscolorselectionviewNavigationBar.buttons[@"RGB"] tap];
    [mscolorselectionviewNavigationBar2.buttons[@"Done"] tap];
}

@end
