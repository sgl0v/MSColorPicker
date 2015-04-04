//
// MSViewController.m
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Maksym Shcheglov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MSColorSelectionViewController.h"
#import <MSColorPicker/MSColorPicker.h>

typedef NS_ENUM (NSUInteger, MSSelectedColorView) {
    MSSelectedColorViewRGB,
    MSSelectedColorViewHSB
};

@interface MSColorSelectionView : UIView <MSColorViewDelegate>

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIView<MSColorView> *rgbColorView;
@property (nonatomic, strong) UIView<MSColorView> *hsbColorView;
@property (nonatomic, strong) UIColor *selectedColor;

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;

@end

@implementation MSColorSelectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _selectedColor = [UIColor whiteColor];
        _rgbColorView = [[MSRGBView alloc] init];
        _hsbColorView = [[MSHSBView alloc] init];
        [self addColorView:_rgbColorView];
        [self addColorView:_hsbColorView];
        [self setSelectedIndex:0 animated:NO];
    }
    return self;
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated
{
    self.selectedIndex = index;
    self.selectedView.value = self.selectedColor;
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

#pragma mark - FBColorViewDelegate methods

- (void)colorView:(id<MSColorView>)colorView didChangeValue:(UIColor *)colorValue
{
    self.selectedColor = colorValue;
}

@end

@interface MSColorSelectionViewController ()

@property (nonatomic, strong) MSColorSelectionView* colorSelectionView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation MSColorSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.colorSelectionView = [[MSColorSelectionView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.colorSelectionView];
    self.colorSelectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_colorSelectionView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_colorSelectionView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_colorSelectionView]|" options:0 metrics:nil views:views]];


    [self.colorSelectionView setSelectedIndex:self.segmentedControl.selectedSegmentIndex animated:NO];
}

- (IBAction)segmentControlDidChangeValue:(UISegmentedControl *)sender
{
    [self.colorSelectionView setSelectedIndex:self.segmentedControl.selectedSegmentIndex animated:YES];
}

@end
