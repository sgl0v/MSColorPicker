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

- (void)testUIElementsPresence
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"Set color programmatically"] tap];

    XCUIElement* window = [app.windows elementBoundByIndex:0];
    XCUIElement* rgbView = app.otherElements[@"rgb_view"];
    XCUIElement* rgbColorSample = [[rgbView.otherElements matchingIdentifier:@"color_sample"] element];
    NSArray<XCUIElement*>* colorComponents = [[rgbView.otherElements matchingIdentifier:@"color_component_view"] allElementsBoundByIndex];
    NSArray<XCUIElement*>* sliders = [[rgbView.otherElements matchingIdentifier:@"color_slider"] allElementsBoundByIndex];
    NSArray<XCUIElement*>* labels = [rgbView.staticTexts allElementsBoundByIndex];

    XCTAssertTrue([rgbView exists]);
    XCTAssertTrue([rgbColorSample exists]);

    XCTAssertEqual(labels.count, 3);
    XCTAssertEqual(sliders.count, 3);
    XCTAssertEqual(colorComponents.count, 3);

    XCUIElement *navigationBar = app.navigationBars[@"MSColorSelectionView"];
    [navigationBar.buttons[@"HSB"] tap];
    XCUIElement* hsbView = app.otherElements[@"hsb_view"];
    XCUIElement* hsbColorSample = [[hsbView.otherElements matchingIdentifier:@"color_sample"] element];
    XCUIElement* colorWheel = app.otherElements[@"color_wheel_view"];

    XCTAssertTrue([hsbView exists]);
    XCTAssertTrue([hsbColorSample exists]);
    XCTAssertTrue([colorWheel exists]);
    XCTAssertEqual([[hsbView.otherElements matchingIdentifier:@"color_component_view"] count], 1);
}

- (void)testColorSelectionFlow
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"Set color programmatically"] tap];

    XCUIElement* window = [app.windows elementBoundByIndex:0];
    XCUIElement* rgbView = app.otherElements[@"rgb_view"];
    XCUIElement* rgbColorSample = [[rgbView.otherElements matchingIdentifier:@"color_sample"] element];
    NSArray<XCUIElement*>* colorComponents = [[rgbView.otherElements matchingIdentifier:@"color_component_view"] allElementsBoundByIndex];
    NSArray<XCUIElement*>* sliders = [[rgbView.otherElements matchingIdentifier:@"color_slider"] allElementsBoundByIndex];
    NSArray<XCUIElement*>* labels = [rgbView.staticTexts allElementsBoundByIndex];

    XCUIElement* redSlider = sliders[0];
    XCTAssertTrue([redSlider exists]);
    [self tapElement:redSlider atPoint:CGPointMake(10.0, 10.0)];

//    XCUIElement* redSlider = [[rgbView.otherElements[@"color_slider"] element] elementBoundByIndex:0];
//    NSLog(@"%d", rgbView.staticTexts.count);

//    XCTAssertEqual( .count, 3); // number of color component's labels
//    
//    XCUIElement *element = [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
//
//    XCUIElementQuery *query = [element childrenMatchingType:XCUIElementTypeAny];
//
//    XCUICoordinate* coordinate = [element coordinateWithNormalizedOffset:CGVectorMake(0.0, 0.5)];
//    [coordinate tap]; // tap to choose color
//    XCUICoordinate* coordinate2 = [coordinate coordinateWithOffset:CGVectorMake(0.5, 0.0)];
//    [coordinate pressForDuration:0.5 thenDragToCoordinate:coordinate2];
//    sleep(5);

    XCUIElement *mscolorselectionviewNavigationBar = app.navigationBars[@"MSColorSelectionView"];
    [mscolorselectionviewNavigationBar.buttons[@"HSB"] tap];

    XCUIElement* colorWheel = app.otherElements[@"color_wheel_view"];
    [[colorWheel coordinateWithNormalizedOffset:CGVectorMake(0.9, 0.5)] tap];


//    [element tap];
    [mscolorselectionviewNavigationBar.buttons[@"RGB"] tap];
    [mscolorselectionviewNavigationBar.buttons[@"Done"] tap];
//    [[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"MSView"] childnMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element tap];

}

- (void)tapElement:(XCUIElement*)element atPoint:(CGPoint)point {
    XCUICoordinate* coordinate = [[element coordinateWithNormalizedOffset:CGVectorMake(0.0, 0.0)] coordinateWithOffset:CGVectorMake(point.x, point.y)];
    [coordinate tap];
}


@end
