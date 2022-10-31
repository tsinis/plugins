//
//  OverlayView.m
//
//  Created by Roman Cinis on 25.10.2022
//  Copyright 2022 Roman Cinis. All rights reserved.
//

#import "OverlayView.h"

// Helper method to be used to clamp opacity between [min] and [max] values.
static CGFloat clamp(CGFloat v, CGFloat min, CGFloat max) {
    return MIN(MAX(v, min), max);
}

// Implementation of the [OverlayView] class.
@implementation OverlayView
// Follows the class description from a "".m" file.
- (id)initWithFrame:(CGRect)frame andPath:(NSString*)path andOpacity:(NSNumber*)opacity {
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO; // Setting the overlay to opaque mode.
        self.backgroundColor = [UIColor clearColor]; // Clears the background color of the overlay.

        // Variable for finding a shortest side, first, ssuming we are in portrait mode.
        float shortestSide = self.bounds.size.width;
        // If overlay is started in landscape mode overlay should be rotated.
        bool isLandscape = shortestSide > self.bounds.size.height;

        // This boolean will be later used, since on iOS 16 view will be automatically
        // rotated to [preferredInterfaceOrientationForPresentation] and also the
        // [shouldAutorotate] flag depricated there (so it's not used at all).
        bool isNewestIos = false;
        // If iOS version is 16.0 or higher/newer, mark it as true.
        if (@available(iOS 16.0, *)) isNewestIos = true;

        // If view is in landscape mode shortest side will be the height of the view.
        if (isLandscape) shortestSide = self.bounds.size.height;

        float cameraAspectRatio = 4.0 / 3.0; // Camera picker always has 4/3 aspect ratio.
        float longestSide = shortestSide * cameraAspectRatio; // So we can calulate the height of the camera preview.

        // Camera preview has different Y offset than it's "preview" on the "Retake/Use Photo" screen:
        // https://stackoverflow.com/questions/28373749/uiimagepickercontrollers-cameraoverlayview-is-offset-after-taking-photo
        int padding = 30;
        // And also position of camera preview is quite different on different iPhone models, since we
        // don't have an access to source code of default camera controls UI it can be only hardcoded this way:
        int paddedOffset = 70 + padding;

        // Change default [padding] and [paddedOffset] values if it's not an older iPhone,
        // since on newer models there is a bigger screen resolution -> bigger offset and padding.
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                case 1136: // iPhone 5/5S/5C/SE
                case 1334: // iPhone 6/6S/7/8
                case 1920: case 2208: // iPhone 6+/6S+/7+/8+
                    break;
                default: // Newer iPhones, some adjustments might be needed here for new models.
                    padding = 40;
                    paddedOffset = 160  + padding;
                    break;
            }
        }
        // Setting offset property to padding value, to be used in [imagePickerController.cameraViewTransform].
        self.offset = (CGFloat)padding;
        // Reduce the height with vertical padding on both sides.
        int paddedLongestSide = longestSide - (padding * 2);
        // Actual frame of the camera preview.
        CGRect previewFrame = (isLandscape || isNewestIos)? CGRectMake(paddedOffset, 0, shortestSide, longestSide) :
                                             CGRectMake(0, paddedOffset, shortestSide, longestSide);

        // Load an image from the [path] to show in the overlay.
        UIImage *overlayImage = [UIImage imageWithContentsOfFile:path];
        // Set this image as Image View.
        UIImageView *overlayView = [[UIImageView alloc] initWithImage:overlayImage];

        // Convert [NSNumber] opacity to the [float]. Opacity is always provided between 0 and 100.
        float floatOpacity = [opacity floatValue];
        // Alpha value have to be between 0 and 1.0. So divide [floatOpacity] by 100
        // to get alpha representation of the [opacity].
        float opacityAlpha = floatOpacity / 100.0f;
        // Clamp [opacityAlpha] just to be sure it's between 0 and 1.0. Convert it to [CGFloat].
        overlayView.alpha = clamp((CGFloat)opacityAlpha, 0.0f, 1.0f);

        // On newst iOS view will be automatically rotated to the landscape mode since it's a
        // [CUIImagePickerController] prefered orientation.
        if (isLandscape || isNewestIos) {
            // Rotate image by 90 degrees in landscape mode.
            overlayView.transform = CGAffineTransformMakeRotation(-(M_PI * (90) / 180.0));
            // Set overlay frame to be exactly as big as camera preview
            // is, but for the landscape orientation.
            overlayView.frame = CGRectMake(0, 0, paddedLongestSide, shortestSide);
        } else {
            // Set overlay frame to be exactly as big as camera preview
            // is, but for the portrait orientation.
            overlayView.frame = CGRectMake(0, 0, shortestSide, paddedLongestSide);
        }

        // Fit the [overlayImage] to be proportionally scaled into the preview frame.
		overlayView.contentMode = UIViewContentModeScaleAspectFit;
        // Add this new image view to the overlay view.
        [self addSubview:overlayView];
        // Adjust overlay view position and size to the camera preview position and size.
        self.frame = previewFrame;
    }
    return self;
}

@end
