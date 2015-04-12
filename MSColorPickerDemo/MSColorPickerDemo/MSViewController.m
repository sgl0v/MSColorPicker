//
//  MSViewController.m
//  MSColorPickerDemo
//
//  Created by Maksym Shcheglov on 03/04/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

#import "MSViewController.h"
#import "MSColorView.h"
#import "MSColorSelectionViewController.h"

@interface MSViewController () <UIPopoverPresentationControllerDelegate, MSColorViewDelegate>

@end

@implementation MSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Assuming you've hooked this all up in a Storyboard with a popover presentation style
    if ([segue.identifier isEqualToString:@"showPopover"]) {
        UINavigationController *destNav = segue.destinationViewController;
        destNav.preferredContentSize = [[destNav visibleViewController].view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        destNav.popoverPresentationController.delegate = self;
        MSColorSelectionViewController* colorSelectionController = (MSColorSelectionViewController*)destNav.visibleViewController;
        colorSelectionController.delegate = self;
        colorSelectionController.color = self.view.backgroundColor;
        if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) { // Add done button for the compact size
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissViewController:)];
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn;
        }
    }
}

#pragma mark - MSColorViewDelegate

- (void)colorView:(id<MSColorView>)colorView didChangeValue:(UIColor *)colorValue
{
    self.view.backgroundColor = colorValue;
}

#pragma mark - UIAdaptivePresentationControllerDelegate methods

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationFullScreen;
}

#pragma mark - Private

- (void)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
