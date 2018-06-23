//
// MSKeyboardManager.m
//
// Created by Maksym Shcheglov on 2014-02-21.
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

#import "MSKeyboardManager.h"

static CGFloat const MSDistanceBetweenKeyboardAndTextfield = 10.0f;

@interface UIView (Utils)
- (id)firstSubviewOfClass:(Class)className;
@end

@implementation UIView (Utils)

- (id)firstSubviewOfClass:(Class)className
{
    return [self firstSubviewOfClass:className depthLevel:3];
}

- (id)firstSubviewOfClass:(Class)className depthLevel:(NSInteger)depthLevel
{
    if (depthLevel == 0) {
        return nil;
    }

    NSInteger count = depthLevel;

    NSArray *subviews = self.subviews;

    while (count > 0) {
        for (UIView *v in subviews) {
            if ([v isKindOfClass:className]) {
                return v;
            }
        }

        count--;

        for (UIView *v in subviews) {
            UIView *retVal = [v firstSubviewOfClass:className depthLevel:count];

            if (retVal) {
                return retVal;
            }
        }
    }

    return nil;
}

@end

@interface MSKeyboardManager ()
{
    UIView *_activeTextField;
}

@end

@implementation MSKeyboardManager

- (instancetype)init
{
    self = [super init];

    if (self) {
        [self enable];
    }

    return self;
}

- (void)enable
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ms_keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];

    // register for testfield notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ms_textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ms_textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)disable
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self disable];
}

#pragma mark - Private methods

- (UIViewController *)ms_topViewController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    if ([topController isKindOfClass:UINavigationController.class]) {
        topController = [(UINavigationController *)topController topViewController];
    }

    return topController;
}

- (void)ms_setRootViewFrame:(CGRect)frame withDuration:(CGFloat)duration options:(UIViewAnimationOptions)options
{
    UIViewController *controller = [self ms_topViewController];

    [UIView animateWithDuration:duration delay:0 options:options animations:^{
         [controller.view setFrame:frame];
     } completion:nil];
}

- (void)ms_keyboardFrameChanged:(NSNotification *)notification
{
    UIView *view = [self ms_topViewController].view;
    UIScrollView *scrollView = [view firstSubviewOfClass:[UIScrollView class]];

    if (scrollView == nil) {
        return;
    }

    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGSize kbSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;


    endFrame = [view.window convertRect:endFrame fromWindow:nil];
    endFrame = [view convertRect:endFrame fromView:view.window];

    CGRect activeTextFieldRect = [_activeTextField.superview convertRect:_activeTextField.frame toView:scrollView];
    CGRect rootViewRect = scrollView.frame;
    CGFloat kbHeight = kbSize.height;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

    if (UIInterfaceOrientationIsLandscape([self ms_topViewController].interfaceOrientation)) {
        kbHeight = kbSize.width;
    }

#pragma GCC diagnostic pop

    CGFloat move = CGRectGetMaxY(activeTextFieldRect) - (CGRectGetHeight(rootViewRect) - kbHeight - MSDistanceBetweenKeyboardAndTextfield);

    void (^ animations)(void) = ^{
        scrollView.contentOffset = CGPointMake(0, move);
        CGFloat height = CGRectGetHeight(view.bounds);
        UIEdgeInsets contentInset = scrollView.contentInset;
        contentInset.bottom = (height - CGRectGetMinY(endFrame));
        scrollView.contentInset = contentInset;

        UIEdgeInsets scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
        scrollIndicatorInsets.bottom = (height - CGRectGetMinY(endFrame));
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
    };

    UIViewAnimationOptions options = (curve << 16) | UIViewAnimationOptionBeginFromCurrentState;

    [UIView animateWithDuration:duration delay:0 options:options animations:animations completion:NULL];
}

- (void)ms_textFieldDidBeginEditing:(NSNotification *)notification
{
    _activeTextField = notification.object;
}

- (void)ms_textFieldDidEndEditing:(NSNotification *)notification
{
    _activeTextField = nil;
}

@end
