//
// MSColorWheelView.h
//
// Created by Maksym Shcheglov on 2016-05-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 *  The color wheel view.
 */
@interface MSColorWheelView : UIControl

/**
 *  The hue value.
 */
@property (nonatomic, assign) CGFloat hue;

/**
 *  The saturation value.
 */
@property (nonatomic, assign) CGFloat saturation;

@end
