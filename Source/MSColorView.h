//
// MSColorView.h
//
// Created by Maksym Shcheglov on 2016-05-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

@protocol MSColorViewDelegate;

/**
 *  The \c MSColorView protocol declares a view's interface for displaying and editing color value.
 */
@protocol MSColorView <NSObject>

@required

/**
 *  The object that acts as the delegate of the receiving color selection view.
 */
@property (nonatomic, weak) id<MSColorViewDelegate> delegate;
/**
 *  The current color.
 */
@property (nonatomic, strong) UIColor *color;

@end

/**
 *  The delegate of a MSColorView object must adopt the MSColorViewDelegate protocol.
 *  Methods of the protocol allow the delegate to handle color value changes.
 */
@protocol MSColorViewDelegate <NSObject>

@required

/**
 *  Tells the data source to return the color components.
 *
 *  @param colorView The color view.
 *  @param color The new color value.
 */
- (void)colorView:(id<MSColorView>)colorView didChangeColor:(UIColor *)color;

@end
