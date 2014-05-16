//
// UIControl+HitTestEdgeInsets.h
//
// Created by Maksym Shcheglov on 2016-04-11.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

@interface UIControl (HitTestEdgeInsets)

/**
 *  Edge inset values are applied to a view bounds to shrink or expand the touchable area.
 */
@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end
