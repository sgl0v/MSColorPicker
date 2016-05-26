//
// MSColorUtils.h
//
// Created by Maksym Shcheglov on 2016-05-31.
// Copyright (c) 2016 Maksym Shcheglov.
// License: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

/**
 *  The structure to represent a color in the Red-Green-Blue-Alpha color space.
 */
typedef struct { CGFloat red, green, blue, alpha; }              RGB;
/**
 *  The structure to represent a color in the hue-saturation-brightness color space.
 */
typedef struct { CGFloat hue, saturation, brightness, alpha; }   HSB;

/**
 *  The maximum value of the RGB color components.
 */
extern CGFloat const MSRGBColorComponentMaxValue;
/**
 *  The maximum value of the alpha component.
 */
extern CGFloat const MSAlphaComponentMaxValue;
/**
 *  The maximum value of the HSB color components.
 */
extern CGFloat const MSHSBColorComponentMaxValue;

/**
 * Converts an RGB color value to HSV.
 * Assumes r, g, and b are contained in the set [0, 1] and
 * returns h, s, and b in the set [0, 1].
 *
 *  @param rgb   The rgb color values
 *  @return The hsb color values
 */
extern HSB MSRGB2HSB(RGB rgb);

/**
 * Converts an HSB color value to RGB.
 * Assumes h, s, and b are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 *  @param outRGB   The rgb color values
 *  @return The hsb color values
 */
extern RGB MSHSB2RGB(HSB hsb);

/**
 *  Returns the rgb values of the color components.
 *
 *  @param color The color value.
 *
 *  @return The values of the color components (including alpha).
 */
extern RGB MSRGBColorComponents(UIColor *color);

/**
 *  Converts hex string to the UIColor representation.
 *
 *  @param color The color value.
 *
 *  @return The hex string color value.
 */
extern NSString * MSHexStringFromColor(UIColor *color);

/**
 *  Converts UIColor value to the hex string.
 *
 *  @param hexString The hex string color value.
 *
 *  @return The color value.
 */
extern UIColor * MSColorFromHexString(NSString *hexString);
