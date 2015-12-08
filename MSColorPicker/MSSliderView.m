//
// MSSliderView.m
//
// Created by Maksym Shcheglov on 2014-01-31.
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

#import "MSSliderView.h"

static const CGFloat MSSliderViewHeight = 28.0f;
static const CGFloat MSSliderViewMinWidth = 150.0f;
static const CGFloat MSSliderViewThumbDimension = 28.0f;
static const CGFloat MSSliderViewTrackHeight = 3.0f;

@interface MSSliderView () {
    @private

    CALayer *_thumbLayer;
    CAGradientLayer *_trackLayer;
}

@end

@implementation MSSliderView

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.accessibilityLabel = @"color_slider";

        _minimumValue = 0.0f;
        _maximumValue = 1.0f;
        _value = 0.0f;

        self.layer.delegate = self;

        _trackLayer = [CAGradientLayer layer];
        _trackLayer.cornerRadius = MSSliderViewTrackHeight / 2.0f;
        _trackLayer.startPoint = CGPointMake(0.0f, 0.5f);
        _trackLayer.endPoint = CGPointMake(1.0f, 0.5f);
        [self.layer addSublayer:_trackLayer];

        _thumbLayer = [CALayer layer];
        _thumbLayer.cornerRadius = MSSliderViewThumbDimension / 2;
        _thumbLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _thumbLayer.shadowColor = [UIColor blackColor].CGColor;
        _thumbLayer.shadowOffset = CGSizeZero;
        _thumbLayer.shadowRadius = 2;
        _thumbLayer.shadowOpacity = 0.5f;
        [self.layer addSublayer:_thumbLayer];

        __attribute__((objc_precise_lifetime)) id color = (__bridge id)[UIColor blueColor].CGColor;
        [self setColors:@[color, color]];
    }

    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(MSSliderViewMinWidth, MSSliderViewHeight);
}

- (void)setValue:(CGFloat)value
{
    if (value < _minimumValue) {
        _value = _minimumValue;
    } else if (value > _maximumValue) {
        _value = _maximumValue;
    } else {
        _value = value;
    }

    [self ms_updateThumbPositionWithValue:_value];
}

- (void)setColors:(NSArray *)colors
{
    NSParameterAssert(colors);
    _trackLayer.colors = colors;
    [self ms_updateLocations];
}

#pragma mark - UIControl touch tracking events

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];

    if (CGRectContainsPoint(CGRectInset(_thumbLayer.frame, -10.0, -10.0), touchPoint)) {
        [self ms_setValueWithPosition:touchPoint.x];
        return YES;
    }

    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];

    [self ms_setValueWithPosition:touchPoint.x];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];

    [self ms_setValueWithPosition:touchPoint.x];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    if (layer == self.layer) {
        CGFloat height = MSSliderViewHeight;
        CGFloat width = CGRectGetWidth(self.bounds);
        _trackLayer.bounds = CGRectMake(0, 0, width, MSSliderViewTrackHeight);
        _trackLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / 2, height / 2);
        _thumbLayer.bounds = CGRectMake(0, 0, MSSliderViewThumbDimension, MSSliderViewThumbDimension);
        [self ms_updateThumbPositionWithValue:_value];
    }
}

#pragma mark - Private methods

- (void)ms_setValueWithPosition:(CGFloat)position
{
    CGFloat width = CGRectGetWidth(self.bounds);

    if (position < 0) {
        position = 0;
    } else if (position > width) {
        position = width;
    }

    CGFloat percentage = position / width;
    CGFloat value = _minimumValue + percentage * (_maximumValue - _minimumValue);
    [self setValue:value];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)ms_updateLocations
{
    NSUInteger size = [_trackLayer.colors count];

    if (size == [_trackLayer.locations count]) {
        return;
    }

    CGFloat step = 1.0f / (size - 1);
    NSMutableArray *locations = [NSMutableArray array];
    [locations addObject:@(0.0f)];

    for (NSUInteger i = 1; i < size - 1; ++i) {
        [locations addObject:@(i * step)];
    }

    [locations addObject:@(1.0f)];
    _trackLayer.locations = [locations copy];
}

- (void)ms_updateThumbPositionWithValue:(CGFloat)value
{
    CGFloat width = CGRectGetWidth(self.bounds);

    if (width == 0) {
        return;
    }

    CGFloat percentage = (_value - _minimumValue) / (_maximumValue - _minimumValue);
    CGFloat position = width * percentage;
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    _thumbLayer.position = CGPointMake(position - ((position - width / 2) / (width / 2)) * MSSliderViewThumbDimension / 2, MSSliderViewHeight / 2);
    [CATransaction commit];
}

@end
