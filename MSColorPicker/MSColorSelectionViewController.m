//
// MSColorSelectionViewController.m
//
// Created by Maksym Shcheglov on 2015-04-12.
//
// The MIT License (MIT)
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
#import "MSColorSelectionView.h"

#import <MSColorPicker/MSColorPicker.h>

@interface MSColorSelectionViewController () <MSColorViewDelegate>

@property (nonatomic, strong) UISegmentedControl *modeSelectionControl;

@end

@implementation MSColorSelectionViewController

- (void)loadView
{
    MSColorSelectionView *colorSelectionView = [[MSColorSelectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.view = colorSelectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.titleView = self.modeSelectionControl;

    [self.colorSelectionView setSelectedIndex:self.colorViewMode animated:NO];
    self.colorSelectionView.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)segmentControlDidChangeValue:(UISegmentedControl *)segmentedControl
{
    if (segmentedControl == self.modeSelectionControl) {
        self.colorViewMode = segmentedControl.selectedSegmentIndex;
    }
}

- (void)setColor:(UIColor *)color
{
    self.colorSelectionView.color = color;
}

- (void)setColorViewMode:(MSSelectedColorView)selectedColorViewMode
{
    if (selectedColorViewMode != _colorViewMode) {
        _colorViewMode = selectedColorViewMode;
        [self.colorSelectionView setSelectedIndex:_colorViewMode animated:YES];
        self.modeSelectionControl.selectedSegmentIndex = _colorViewMode;
    }
}

-(UISegmentedControl *)modeSelectionControl {
    if (_modeSelectionControl == nil) {
        _modeSelectionControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"RGB", ), NSLocalizedString(@"HSB", )]];
        [_modeSelectionControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
        _modeSelectionControl.selectedSegmentIndex = self.colorViewMode;
    }
    return _modeSelectionControl;
}

- (UIColor *)color
{
    return self.colorSelectionView.color;
}

- (void)viewWillLayoutSubviews
{
    [self.colorSelectionView setNeedsUpdateConstraints];
    [self.colorSelectionView updateConstraintsIfNeeded];
}

- (MSColorSelectionView *)colorSelectionView
{
    return (MSColorSelectionView *)self.view;
}

#pragma mark - MSColorViewDelegate

- (void)colorView:(id<MSColorView>)colorView didChangeColor:(UIColor *)color
{
    [self.delegate colorViewController:self didChangeColor:color];
}

@end
