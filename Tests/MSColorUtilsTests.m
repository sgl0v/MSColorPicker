//
// MSColorUtilsTests.m
//
// Created by Maksym Shcheglov on 2014-08-18.
//
// The MIT License (MIT)
// Copyright (c) 2015 Maksym Shcheglov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <MSColorPicker/MSColorPicker.h>

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
    HSB expectedColor = MSRGB2HSB((RGB) {.red = 1.0f, .green = 0.0f, .blue = 1.0f, .alpha = 1.0f });
    HSB resultColor = MSRGB2HSB(MSHSB2RGB(expectedColor));

    XCTAssertTrue(isEqualHSBValues(expectedColor, resultColor), @"The UIColor result is not correct!");
}

- (void)testHSB2RGB
{
    RGB expectedColor = { .red = 1.0f, .green = 0.0f, .blue = 1.0f, .alpha = 1.0f };
    RGB resultColor = MSHSB2RGB(MSRGB2HSB(expectedColor));

    XCTAssertTrue(isEqualRGBValues(expectedColor, resultColor), @"The UIColor result is not correct!");
}

- (void)testRGBColorComponents
{
    RGB expectedColor = { .red = 1.0f, .green = 0.0f, .blue = 0.0f, .alpha = 1.0f };
    RGB resultColor = MSRGBColorComponents([UIColor redColor]);

    XCTAssertTrue(isEqualRGBValues(expectedColor, resultColor), @"The UIColor result is not correct!");
}

- (void)testHexStringFromColor
{
    XCTAssertNil(MSHexStringFromColor(nil), @"The method should return nil for invalid input parameters!");
    NSString *expectedHexColor = @"#FF0000FF";
    XCTAssertEqualObjects(expectedHexColor, MSHexStringFromColor([UIColor redColor]), @"The color's hex value is not correct!");
    XCTAssertEqualObjects(expectedHexColor, MSHexStringFromColor([UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]), @"The color's hex value is not correct!");
}

- (void)testColorFromHexString
{
    XCTAssertNil(MSColorFromHexString(@"FF0000"), @"The method should return nil for invalid input parameters!");
    NSString *hexColor = @"#FF0000FF";
    RGB expectedColor = MSRGBColorComponents([UIColor redColor]);
    RGB resultColor = MSRGBColorComponents(MSColorFromHexString(hexColor));
    XCTAssertTrue(isEqualRGBValues(expectedColor, resultColor), @"The UIColor result is not correct!");
}

@end
