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

@interface MSViewController () <MSColorViewDelegate>
{
    UIView<MSColorView>* _currentView;
    NSArray* _colorSelectionViews;
    UIColor* _currentColorValue;
}

@end

@implementation MSViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _currentColorValue = [UIColor whiteColor];
    UISegmentedControl* segmentedControl = [self _createSegmentedControl];
    self.navigationItem.titleView = segmentedControl;
    segmentedControl.selectedSegmentIndex = 0;
    [self _segmentControlDidChangeValue:segmentedControl];
}

#pragma mark - FBColorViewDelegate methods

- (void)colorView:(id<MSColorView>)colorView didChangeValue:(UIColor*)colorValue
{
    _currentColorValue = colorValue;
}

#pragma mark - Private methods

- (UIView<MSColorView>*)_colorSelectionViewAtIndex:(NSUInteger)idx
{
    if (!_colorSelectionViews) {
        UIView* rgbView = [[MSRGBView alloc] initWithFrame:self.view.bounds];
        UIView* hsbView = [[MSHSBView alloc] initWithFrame:self.view.bounds];
        _colorSelectionViews = @[rgbView, hsbView];
    }
    return idx < [_colorSelectionViews count] ? _colorSelectionViews[idx] : nil;
}

- (IBAction)_segmentControlDidChangeValue:(UISegmentedControl*)sender
{
    _currentView.delegate = nil;
    [_currentView removeFromSuperview];
    _currentView = [self _colorSelectionViewAtIndex:sender.selectedSegmentIndex];
    _currentView.value = _currentColorValue;
    _currentView.delegate = self;
    [self _applyNavBarInsetsForView:_currentView];
    [self.view addSubview:_currentView];
    _currentView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_currentView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_currentView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_currentView]|" options:0 metrics:nil views:views]];
}

- (UISegmentedControl*)_createSegmentedControl
{
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"RGB", @"HSB"]];
    [segmentedControl addTarget:self action:@selector(_segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl sizeToFit];
    return segmentedControl;
}

- (void)_applyNavBarInsetsForView:(UIView<MSColorView>*)view
{
    // For insetting with a navigation bar
    CGFloat topInset = CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        topInset = CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetWidth([UIApplication sharedApplication].statusBarFrame);
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(topInset, 0, 0, 0);
    view.scrollView.contentInset = insets;
    view.scrollView.scrollIndicatorInsets = insets;
}

@end
