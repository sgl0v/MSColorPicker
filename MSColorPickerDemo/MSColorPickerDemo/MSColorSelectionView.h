//
//  MSColorSelectionView.h
//  MSColorPickerDemo
//
//  Created by Maksym Shcheglov on 10/04/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSColorView.h"

typedef NS_ENUM (NSUInteger, MSSelectedColorView) {
	MSSelectedColorViewRGB,
	MSSelectedColorViewHSB
};

/**
 *  The MSColorSelectionView aggregates views that should be used to edit color components.
 */
@interface MSColorSelectionView : UIView <MSColorView>

//! @abstract The selected view's index
@property (nonatomic, assign, readonly) MSSelectedColorView selectedIndex;

/**
 *  Makes a color component view (rgb or hsb) visible according to the index.
 *
 *  @param index    This index define a view to show.
 *  @param animated If YES, the view is being appeared using an animation.
 */
- (void)setSelectedIndex:(MSSelectedColorView)index animated:(BOOL)animated;

@end
