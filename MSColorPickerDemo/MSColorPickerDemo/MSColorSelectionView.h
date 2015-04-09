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

@interface MSColorSelectionView : UIView

@property (nonatomic, assign) MSSelectedColorView selectedIndex;
@property (nonatomic, strong) UIView<MSColorView> *rgbColorView;
@property (nonatomic, strong) UIView<MSColorView> *hsbColorView;
@property (nonatomic, strong) UIColor *selectedColor;

- (void)setSelectedIndex:(MSSelectedColorView)index animated:(BOOL)animated;

@end