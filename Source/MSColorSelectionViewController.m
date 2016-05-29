//
// MSColorSelectionViewController.m
//
// Created by Maksym Shcheglov on 2016-05-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import "MSColorSelectionViewController.h"
#import "MSColorSelectionView.h"

#import "MSColorPicker.h"

@interface MSColorSelectionViewController () <MSColorViewDelegate>

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

    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"RGB", ), NSLocalizedString(@"HSB", )]];
    [segmentControl addTarget:self action:@selector(segmentControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentControl;

    [self.colorSelectionView setSelectedIndex:0 animated:NO];
    self.colorSelectionView.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)segmentControlDidChangeValue:(UISegmentedControl *)segmentedControl
{
    [self.colorSelectionView setSelectedIndex:segmentedControl.selectedSegmentIndex animated:YES];
}

- (void)setColor:(UIColor *)color
{
    self.colorSelectionView.color = color;
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
