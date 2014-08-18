//
//  MSColorPickerDemoTests.m
//  MSColorPickerDemoTests
//
//  Created by Maksym Shcheglov on 07/05/14.
//  Copyright (c) 2014 Maksym Shcheglov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

#import "MSColorUtils.h"

bool isEqualRGBValues(RGB first, RGB second)
{
    return first.red == second.red && first.green == second.green && first.blue == second.blue && first.alpha == second.alpha;
}

bool isEqualHSBValues(HSB first, HSB second)
{
    return first.hue == second.hue && first.saturation == second.saturation && first.brightness == second.brightness && first.alpha == second.alpha;
}

@interface MSColorUtilsTests : XCTestCase

@end

@implementation MSColorUtilsTests

- (void)setUp
{
    [super setUp];

}

- (void)testRGB2HSB
{
    HSB expectedColor = MSRGB2HSB((RGB){.red = 1.0f, .green = 0.0f, .blue = 1.0f, .alpha = 1.0f});
    HSB resultColor = MSRGB2HSB(MSHSB2RGB(expectedColor));
    XCTAssertTrue(isEqualHSBValues(expectedColor, resultColor), @"The UIColor result is not correct!");
}

- (void)testHSB2RGB
{
    RGB expectedColor = {.red = 1.0f, .green = 0.0f, .blue = 1.0f, .alpha = 1.0f};
    RGB resultColor = MSHSB2RGB(MSRGB2HSB(expectedColor));
    XCTAssertTrue(isEqualRGBValues(expectedColor, resultColor), @"The UIColor result is not correct!");
}

- (void)testRGBColorComponents
{
    RGB expectedColor = {.red = 1.0f, .green = 0.0f, .blue = 0.0f, .alpha = 1.0f};
    RGB resultColor = MSRGBColorComponents([UIColor redColor]);
    XCTAssertTrue(isEqualRGBValues(expectedColor, resultColor), @"The UIColor result is not correct!");
}

- (void)testHexStringFromColor
{
    XCTAssertNil(MSHexStringFromColor(nil), @"The method should return nil for invalid input parameters!");
    NSString* expectedHexColor = @"#FF0000FF";
    XCTAssertEqualObjects(expectedHexColor, MSHexStringFromColor([UIColor redColor]), @"The color's hex value is not correct!");
    XCTAssertEqualObjects(expectedHexColor, MSHexStringFromColor([UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]), @"The color's hex value is not correct!");
}

- (void)testColorFromHexString
{
    XCTAssertNil(MSColorFromHexString(@"FF0000"), @"The method should return nil for invalid input parameters!");
    NSString* hexColor = @"#FF0000FF";
    RGB expectedColor = MSRGBColorComponents([UIColor redColor]);
    RGB resultColor = MSRGBColorComponents(MSColorFromHexString(hexColor));
    XCTAssertTrue(isEqualRGBValues(expectedColor, resultColor), @"The UIColor result is not correct!");
}

@end
