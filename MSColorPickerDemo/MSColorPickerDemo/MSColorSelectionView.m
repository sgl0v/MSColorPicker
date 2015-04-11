//
//  MSColorSelectionView.m
//  MSColorPickerDemo
//
//  Created by Maksym Shcheglov on 10/04/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

#import "MSColorSelectionView.h"
#import <MSColorPicker/MSColorPicker.h>

@interface MSColorSelectionView () <MSColorViewDelegate>

@property (nonatomic, strong) UIView <MSColorView> *rgbColorView;
@property (nonatomic, strong) UIView <MSColorView> *hsbColorView;
@property (nonatomic, assign) MSSelectedColorView selectedIndex;
@property (nonatomic, strong) UIColor* color;

@end

@implementation MSColorSelectionView

@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _rgbColorView = [[MSRGBView alloc] init];
        _hsbColorView = [[MSHSBView alloc] init];
        [self addColorView:_rgbColorView];
        [self addColorView:_hsbColorView];
        [self setSelectedIndex:0 animated:NO];
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [[self selectedView] setColor:color];
}

- (void)setSelectedIndex:(MSSelectedColorView)index animated:(BOOL)animated
{
    self.selectedIndex = index;
    self.selectedView.color = self.color;
    [UIView animateWithDuration:animated ? .5 : 0.0 animations:^{
        self.rgbColorView.alpha = index == 0 ? 1.0 : 0.0;
        self.hsbColorView.alpha = index == 1 ? 1.0 : 0.0;
    } completion:nil];
}

- (UIView<MSColorView> *)selectedView
{
    return self.selectedIndex == 0 ? self.rgbColorView : self.hsbColorView;
}

- (void)addColorView:(UIView<MSColorView>*)view
{
    view.delegate = self;
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
}

- (void)updateConstraints
{
    [self.rgbColorView setNeedsUpdateConstraints];
    [self.hsbColorView setNeedsUpdateConstraints];
    [super updateConstraints];
}

#pragma mark - FBColorViewDelegate methods

- (void)colorView:(id<MSColorView>)colorView didChangeValue:(UIColor *)colorValue
{
    self.color = colorValue;
    [self.delegate colorView:self didChangeValue:self.color];
}

@end
