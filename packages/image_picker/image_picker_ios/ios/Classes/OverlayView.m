//
//  OverlayView.m
//
//  Created by Roman Cinis on 25.10.2022
//  Copyright 2022 Roman Cinis. All rights reserved.
//

#import "OverlayView.h"

static CGFloat clamp(CGFloat v, CGFloat min, CGFloat max) {
    return MIN(MAX(v, min), max);
}

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame andPath:(NSString*)path andOpacity:(NSNumber*)opacity {
    if (self = [super initWithFrame:frame]) {
        //clear the background color of the overlay
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];

        float cameraAspectRatio = 4.0 / 3.0;
        float previewWidth = self.bounds.size.width;
        float previewHeight = previewWidth * cameraAspectRatio;

        // https://stackoverflow.com/questions/28373749/uiimagepickercontrollers-cameraoverlayview-is-offset-after-taking-photo
        int padding = 30;
        // workaround, to overlay the camera preview, and not the controls.
        int topOffset = 70 + padding;

        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                case 1136: // iPhone 5/5S/5C/SE
                case 1334: // iPhone 6/6S/7/8
                case 1920: case 2208: // iPhone 6+/6S+/7+/8+
                    break;
                default:
                    padding = 40;
                    topOffset = 160  + padding;
                    break;
            }
        }
        self.offset = (CGFloat)padding;
        int paddedHeight = previewHeight - (padding * 2);
        CGRect previewFrame = CGRectMake(0, topOffset, previewWidth, paddedHeight);

        // load an image to show in the overlay
        UIImage *overlayImage = [UIImage imageWithContentsOfFile:path];
        UIImageView *overlayView = [[UIImageView alloc] initWithImage:overlayImage];
        float floatOpacity = [opacity floatValue];
        float opacityPercents = floatOpacity / 100.0f;
        overlayView.alpha = clamp((CGFloat)floatOpacity, 0.0f, 1.0f);
        overlayView.frame = CGRectMake(0, 0, previewWidth, paddedHeight);
		overlayView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:overlayView];
        self.frame = previewFrame;
    }
    return self;
}

@end
