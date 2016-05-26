//
// MSSliderView.h
//
// Created by Maksym Shcheglov on 2016-05-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

/**
 *  The slider with a gradient track.
 */
@interface MSSliderView : UIControl

/**
 *  The slider's current value. The default value is 0.0.
 */
@property (nonatomic, assign) CGFloat value;
/**
 *  The minimum value of the slider. The default value is 0.0.
 */
@property (nonatomic, assign) CGFloat minimumValue;
/**
 *  The maximum value of the slider. The default value is 1.0.
 */
@property (nonatomic, assign) CGFloat maximumValue;
/**
 *  Sets the array of CGColorRef objects defining the color of each gradient stop on the track.
 *  The location of each gradient stop is evaluated with formula: i * width_of_the_track / number_of_colors.
 *
 *  @param colors An array of CGColorRef objects.
 */
- (void)setColors:(NSArray *)colors __attribute__((nonnull(1)));

@end
