//
// MSColorComponentView.m
//
// Created by Maksym Shcheglov on 2016-05-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import "MSColorComponentView.h"
#import "MSSliderView.h"

// Temporary disabled the color component editing via text field
//#define COLOR_TEXT_FIELD_ENABLED

extern CGFloat const MSRGBColorComponentMaxValue;
static CGFloat const MSColorComponentViewSpacing = 5.0f;
static CGFloat const MSColorComponentLabelWidth = 60.0f;
//static CGFloat const MSColorComponentTextFieldWidth = 50.0f;

@interface MSColorComponentView () <UITextFieldDelegate>
{
    @private

    UILabel *_label;
    MSSliderView *_slider; // The color slider to edit color component.
    UITextField *_textField;
}

@end

@implementation MSColorComponentView

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

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

- (void)setTitle:(NSString *)title
{
    _label.text = title;
}

- (void)setMinimumValue:(CGFloat)minimumValue
{
    _slider.minimumValue = minimumValue;
}

- (void)setMaximumValue:(CGFloat)maximumValue
{
    _slider.maximumValue = maximumValue;
}

- (void)setValue:(CGFloat)value
{
    _slider.value = value;
    _textField.text = [NSString stringWithFormat:_format, value];
}

- (NSString *)title
{
    return _label.text;
}

- (CGFloat)minimumValue
{
    return _slider.minimumValue;
}

- (CGFloat)maximumValue
{
    return _slider.maximumValue;
}

- (CGFloat)value
{
    return _slider.value;
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setValue:[textField.text floatValue]];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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

    return [newString floatValue] <= _slider.maximumValue;
}

- (void)setColors:(NSArray *)colors
{
    NSParameterAssert(colors);
    [_slider setColors:colors];
}

#pragma mark - Private methods

- (void)ms_baseInit
{
    self.accessibilityLabel = @"color_component_view";

    _format = @"%.f";

    _label = [[UILabel alloc] init];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_label];

    _slider = [[MSSliderView alloc] init];
    _slider.maximumValue = MSRGBColorComponentMaxValue;
    _slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_slider];

#ifdef COLOR_TEXT_FIELD_ENABLED
    _textField = [[UITextField alloc] init];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    [_textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self addSubview:_textField];
#endif

    [self setValue:0.0f];
    [_slider addTarget:self action:@selector(ms_didChangeSliderValue:) forControlEvents:UIControlEventValueChanged];
    [_textField setDelegate:self];

    [self ms_installConstraints];
}

- (void)ms_didChangeSliderValue:(MSSliderView *)sender
{
    [self setValue:sender.value];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)ms_installConstraints
{
#ifdef COLOR_TEXT_FIELD_ENABLED
    NSDictionary *views = @{ @"label": _label, @"slider": _slider, @"textField": _textField };
    NSDictionary *metrics = @{ @"spacing": @(MSColorComponentViewSpacing),
                               @"label_width": @(MSColorComponentLabelWidth),
                               @"textfield_width": @(MSColorComponentTextFieldWidth) };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label(label_width)]-spacing-[slider]-spacing-[textField(textfield_width)]|"
                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textField]|" options:0 metrics:nil views:views]];
#else
    NSDictionary *views = @{ @"label": _label, @"slider": _slider };
    NSDictionary *metrics = @{ @"spacing": @(MSColorComponentViewSpacing),
                               @"label_width": @(MSColorComponentLabelWidth) };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label(label_width)]-spacing-[slider]-spacing-|"
                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:views]];

#endif
}

@end
