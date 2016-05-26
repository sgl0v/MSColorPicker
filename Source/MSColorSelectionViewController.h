//
// MSColorSelectionViewController.h
//
// Created by Maksym Shcheglov on 2016-05-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

@class MSColorSelectionViewController;

/**
 *  The delegate of a MSColorSelectionViewController object must adopt the MSColorSelectionViewController protocol.
 *  Methods of the protocol allow the delegate to handle color value changes.
 */
@protocol MSColorSelectionViewControllerDelegate <NSObject>

@required

/**
 *  Tells the data source to return the color components.
 *
 *  @param colorViewCntroller The color view.
 *  @param color The new color value.
 */
- (void)colorViewController:(MSColorSelectionViewController *)colorViewCntroller didChangeColor:(UIColor *)color;

@end

@interface MSColorSelectionViewController : UIViewController

/**
 *  The controller's delegate. Controller notifies a delegate on color change.
 */
@property (nonatomic, weak) id<MSColorSelectionViewControllerDelegate> delegate;
/**
 *  The current color value.
 */
@property (nonatomic, strong) UIColor *color;

@end
