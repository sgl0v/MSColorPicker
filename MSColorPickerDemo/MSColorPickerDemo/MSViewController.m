//
// MSViewController.m
// MSColorPickerDemo
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Maksym Shcheglov
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

#import "MSViewController.h"
#import "MSColorView.h"
#import "MSRGBView.h"
#import "MSHSBView.h"

typedef NS_ENUM (NSUInteger, MSSelectedColorView) {
    MSSelectedColorViewRGB,
    MSSelectedColorViewHSB
};

@interface MSViewController () <MSColorViewDelegate>

@property (nonatomic, strong) UIView<MSColorView> *currentColorView;
@property (nonatomic, strong) UIView<MSColorView> *rgbColorView;
@property (nonatomic, strong) UIView<MSColorView> *hsbColorView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIColor *selectedColor;

@end

@implementation MSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedColor = [UIColor whiteColor];
    [self ms_updateContentWithSelectedView:self.segmentedControl.selectedSegmentIndex];
}

- (IBAction)segmentControlDidChangeValue:(UISegmentedControl *)sender
{
    [self ms_updateContentWithSelectedView:self.segmentedControl.selectedSegmentIndex];
}

- (UIView<MSColorView> *)rgbColorView
{
    if (!_rgbColorView) {
        _rgbColorView = [[MSRGBView alloc] init];
    }

    return _rgbColorView;
}

- (UIView<MSColorView> *)hsbColorView
{
    if (!_hsbColorView) {
        _hsbColorView = [[MSHSBView alloc] init];
    }

    return _hsbColorView;
}

#pragma mark - FBColorViewDelegate methods

- (void)colorView:(id<MSColorView>)colorView didChangeValue:(UIColor *)colorValue
{
    self.selectedColor = colorValue;
}

#pragma mark - Private methods

- (void)ms_updateContentWithSelectedView:(MSSelectedColorView)selectedView
{
    self.currentColorView.delegate = nil;
    [self.currentColorView removeFromSuperview];
    self.currentColorView = selectedView == MSSelectedColorViewRGB ? self.rgbColorView : self.hsbColorView;
    self.currentColorView.delegate = self;
    [self.scrollView addSubview:self.currentColorView];

    self.currentColorView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_currentColorView);
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.currentColorView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_currentColorView]|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_currentColorView]|" options:0 metrics:nil views:views]];

    self.currentColorView.value = self.selectedColor;
}

@end
