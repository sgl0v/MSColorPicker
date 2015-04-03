//
// MSHSBView.m
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

#import "MSHSBView.h"
#import "MSColorWheelView.h"
#import "MSColorComponentView.h"
#import "MSSliderView.h"
#import "MSColorUtils.h"

extern CGFloat const MSAlphaComponentMaxValue;
extern CGFloat const MSHSBColorComponentMaxValue;

static CGFloat const MSColorSampleViewHeight = 30.0f;
static CGFloat const MSViewSpacing = 20.0f;
static CGFloat const MSViewMargin = 10.0f;
static CGFloat const MSTextFieldWidth = 50.0f;
static CGFloat const MSLabelSpacing = 5.0f;
static CGFloat const MSColorWheelHeight = 200.0f;

@interface MSHSBView () <UITextFieldDelegate>
{
    @private

    MSColorWheelView *_colorWheel;
    MSColorComponentView *_brightnessView;
    MSColorComponentView *_alphaView;
    UIView *_colorSample;
    UIView *_hsView;
    UILabel *_hueLabel;
    UITextField *_hueTextField;
    UILabel *_saturationLabel;
    UITextField *_saturationTextField;

    HSB _colorComponents;
}

@end

@implementation MSHSBView

@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self ms_baseInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self ms_baseInit];
    }

    return self;
}

- (void)reloadData
{
    [_colorSample setBackgroundColor:self.value];
    [self ms_reloadViewsWithColorComponents:_colorComponents];
}

- (void)setValue:(UIColor *)value
{
    _colorComponents = MSRGB2HSB(MSRGBColorComponents(value));
    [self reloadData];
}

- (UIColor *)value
{
    return [UIColor colorWithHue:_colorComponents.hue saturation:_colorComponents.saturation brightness:_colorComponents.brightness alpha:_colorComponents.alpha];
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _hueTextField) {
        _colorComponents.hue = [textField.text floatValue];
    } else if (textField == _saturationTextField) {
        _colorComponents.saturation = [textField.text floatValue];
    }

    [self.delegate colorView:self didChangeValue:[self value]];
    [self reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    //first, check if the new string is numeric only. If not, return NO;
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789,."] invertedSet];

    if ([newString rangeOfCharacterFromSet:characterSet].location != NSNotFound) {
        return NO;
    }

    return [newString floatValue] <= MSHSBColorComponentMaxValue;
}

#pragma mark - Private methods

- (void)ms_baseInit
{
    _colorSample = [[UIView alloc] init];
    _colorSample.layer.borderColor = [UIColor blackColor].CGColor;
    _colorSample.layer.borderWidth = .5f;
    _colorSample.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_colorSample];

    _colorWheel = [[MSColorWheelView alloc] init];
    _colorWheel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_colorWheel];

    _hsView = [[UIView alloc] init];
    _hsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_hsView];

    _hueLabel = [[UILabel alloc] init];
    _hueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_hueLabel setText:@"Hue:"];
    [_hueLabel sizeToFit];
    [_hsView addSubview:_hueLabel];

    _hueTextField = [[UITextField alloc] init];
    _hueTextField.borderStyle = UITextBorderStyleRoundedRect;
    _hueTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [_hueTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_hsView addSubview:_hueTextField];

    _saturationLabel = [[UILabel alloc] init];
    _saturationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_saturationLabel setText:@"Sat:"];
    [_saturationLabel sizeToFit];
    [_hsView addSubview:_saturationLabel];

    _saturationTextField = [[UITextField alloc] init];
    _saturationTextField.borderStyle = UITextBorderStyleRoundedRect;
    _saturationTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [_saturationTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_hsView addSubview:_saturationTextField];


    _brightnessView = [[MSColorComponentView alloc] init];
    _brightnessView.title = @"Brightness";
    _brightnessView.maximumValue = MSHSBColorComponentMaxValue;
    _brightnessView.format = @"%.2f";
    _brightnessView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_brightnessView];


    _alphaView = [[MSColorComponentView alloc] init];
    _alphaView.title = @"Alpha";
    _alphaView.translatesAutoresizingMaskIntoConstraints = NO;
    _alphaView.maximumValue = MSAlphaComponentMaxValue;
    [self addSubview:_alphaView];

    [_colorWheel addTarget:self action:@selector(ms_colorDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    [_brightnessView addTarget:self action:@selector(ms_brightnessDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    [_alphaView addTarget:self action:@selector(ms_alphaDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    _hueTextField.delegate = self;
    _saturationTextField.delegate = self;

    [self ms_installConstraints];
}

- (void)ms_installConstraints
{
    NSDictionary *metrics = @{ @"spacing": @(MSViewSpacing),
                               @"height": @(MSColorSampleViewHeight),
                               @"margin": @(MSViewMargin),
                               @"text_field_width": @(MSTextFieldWidth),
                               @"color_wheel_height": @(MSColorWheelHeight),
                               @"small_spacing": @(MSLabelSpacing) };

    NSDictionary *views = NSDictionaryOfVariableBindings(_colorSample, _colorWheel);

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_colorSample]-margin-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_colorWheel(color_wheel_height)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-spacing-[_colorSample(height)]-spacing-[_colorWheel]" options:0 metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_colorWheel
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_colorWheel
                                  attribute:NSLayoutAttributeHeight
                                 multiplier:1.0f
                                   constant:0]];

    views = NSDictionaryOfVariableBindings(_colorSample, _colorWheel, _hsView, _hueLabel, _hueTextField, _saturationLabel, _saturationTextField);
    [_hsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_hueLabel]-small_spacing-[_hueTextField(text_field_width)]|" options:0 metrics:metrics views:views]];
    [_hsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_saturationLabel]-small_spacing-[_saturationTextField(text_field_width)]|" options:0 metrics:metrics views:views]];
    [_hsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_hueLabel]-margin-[_saturationLabel]|" options:0 metrics:metrics views:views]];
    [_hsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_hueTextField]-margin-[_saturationTextField]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_colorWheel]-margin-[_hsView]" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];

    views = NSDictionaryOfVariableBindings(_colorWheel, _brightnessView, _alphaView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_brightnessView]-margin-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_colorWheel]-spacing-[_brightnessView]" options:0 metrics:metrics views:views]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_alphaView]-margin-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_brightnessView]-spacing-[_alphaView]-|" options:0 metrics:metrics views:views]];
}

- (void)ms_reloadViewsWithColorComponents:(HSB)colorComponents
{
    _colorWheel.hue = colorComponents.hue;
    _colorWheel.saturation = colorComponents.saturation;
    [self ms_updateSlidersWithColorComponents:colorComponents];
    [self ms_updateTextFieldsWithColorComponents:colorComponents];
}

- (void)ms_updateSlidersWithColorComponents:(HSB)colorComponents
{
    [_alphaView setValue:colorComponents.alpha * MSAlphaComponentMaxValue];
    [_brightnessView setValue:colorComponents.brightness];
    UIColor *tmp = [UIColor colorWithHue:colorComponents.hue saturation:colorComponents.saturation brightness:1.0f alpha:1.0f];
    [_brightnessView setColors:@[(id)[UIColor blackColor].CGColor, (id)tmp.CGColor]];
}

- (void)ms_updateTextFieldsWithColorComponents:(HSB)colorComponents
{
    _hueTextField.text = [NSString stringWithFormat:@"%.2f", colorComponents.hue];
    _saturationTextField.text = [NSString stringWithFormat:@"%.2f", colorComponents.saturation];
}

- (void)ms_colorDidChangeValue:(MSColorWheelView *)sender
{
    _colorComponents.hue = sender.hue;
    _colorComponents.saturation = sender.saturation;
    [self.delegate colorView:self didChangeValue:[self value]];
    [self reloadData];
}

- (void)ms_brightnessDidChangeValue:(MSColorComponentView *)sender
{
    _colorComponents.brightness = sender.value;
    [self.delegate colorView:self didChangeValue:[self value]];
    [self reloadData];
}

- (void)ms_alphaDidChangeValue:(MSColorComponentView *)sender
{
    _colorComponents.alpha = sender.value / MSAlphaComponentMaxValue;
    [self.delegate colorView:self didChangeValue:[self value]];
    [self reloadData];
}

@end
