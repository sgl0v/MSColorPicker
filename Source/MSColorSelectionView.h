//
// MSColorSelectionView.h
//
// Created by Maksym Shcheglov on 2016-05-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

#import "MSColorView.h"

/**
 *  The enum to define the MSColorView's types.
 */
typedef NS_ENUM (NSUInteger, MSSelectedColorView) {
    /**
     *  The RGB color view type.
     */
    MSSelectedColorViewRGB,
    /**
     *  The HSB color view type.
     */
    MSSelectedColorViewHSB
};

/**
 *  The MSColorSelectionView aggregates views that should be used to edit color components.
 */
@interface MSColorSelectionView : UIView <MSColorView>

/**
 *  The selected color view
 */
@property (nonatomic, assign, readonly) MSSelectedColorView selectedIndex;

/**
 *  Makes a color component view (rgb or hsb) visible according to the index.
 *
 *  @param index    This index define a view to show.
 *  @param animated If YES, the view is being appeared using an animation.
 */
- (void)setSelectedIndex:(MSSelectedColorView)index animated:(BOOL)animated;

@end
