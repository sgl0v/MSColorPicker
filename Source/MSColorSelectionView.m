//
// MSColorSelectionView.m
//
// Created by Maksym Shcheglov on 2016-05-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import "MSColorSelectionView.h"
#import "MSRGBView.h"
#import "MSHSBView.h"

@interface MSColorSelectionView () <MSColorViewDelegate>

@property (nonatomic, strong) UIView <MSColorView> *rgbColorView;
@property (nonatomic, strong) UIView <MSColorView> *hsbColorView;
@property (nonatomic, assign) MSSelectedColorView selectedIndex;

@end

@implementation MSColorSelectionView

@synthesize color = _color;
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self != nil) {
        [self ms_init];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self != nil) {
        [self ms_init];
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

- (void)addColorView:(UIView<MSColorView> *)view
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

- (void)colorView:(id<MSColorView>)colorView didChangeColor:(UIColor *)color
{
    self.color = color;
    [self.delegate colorView:self didChangeColor:self.color];
}

#pragma mark - Private

- (void)ms_init
{
    self.accessibilityLabel = @"color_selection_view";

    self.backgroundColor = [UIColor whiteColor];
    self.rgbColorView = [[MSRGBView alloc] init];
    self.hsbColorView = [[MSHSBView alloc] init];
    [self addColorView:self.rgbColorView];
    [self addColorView:self.hsbColorView];
    [self setSelectedIndex:0 animated:NO];
}

@end
