//
//  MSColorSelectionView.h
//  MSColorPickerDemo
//
//  Created by Maksym Shcheglov on 10/04/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSColorView;

typedef NS_ENUM (NSUInteger, MSSelectedColorView) {
	MSSelectedColorViewRGB,
	MSSelectedColorViewHSB
};

/**
 *  The MSColorSelectionView aggregates views that should be used to edit color components.
 */
@interface MSColorSelectionView : UIView

@property (nonatomic, assign) MSSelectedColorView selectedIndex;
//! @abstract This view represents rgb color components
@property (nonatomic, strong) UIView <MSColorView> *rgbColorView;
//! @abstract This view represents hsb color components
@property (nonatomic, strong) UIView <MSColorView> *hsbColorView;
//! @abstract The selected color
@property (nonatomic, strong) UIColor *selectedColor;

/**
 *  Makes a color component view (rgb or hsb) visible according to the index.
 *
 *  @param index    This index define a view to show.
 *  @param animated If YES, the view is being appeared using an animation.
 */
- (void)setSelectedIndex:(MSSelectedColorView)index animated:(BOOL)animated;

@end
