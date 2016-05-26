//
// MSColorComponentView.h
//
// Created by Maksym Shcheglov on 2016-05-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

@class MSSliderView;

/**
 *  The view to edit a color component.
 */
@interface MSColorComponentView : UIControl

/**
 *  The title.
 */
@property (nonatomic, copy) NSString *title;

/**
 *  The current value. The default value is 0.0.
 */
@property (nonatomic, assign) CGFloat value;

/**
 *  The minimum value. The default value is 0.0.
 */
@property (nonatomic, assign) CGFloat minimumValue;

/**
 *  The maximum value. The default value is 255.0.
 */
@property (nonatomic, assign) CGFloat maximumValue;

/**
 *  The format string to use apply for textfield value. \c %.f by default.
 */
@property (nonatomic, copy) NSString *format;

/**
 *  Sets the array of CGColorRef objects defining the color of each gradient stop on a slider's track.
 *  The location of each gradient stop is evaluated with formula: i * width_of_the_track / number_of_colors.
 *
 *  @param colors An array of CGColorRef objects.
 */
- (void)setColors:(NSArray *)colors __attribute__((nonnull(1)));

@end
