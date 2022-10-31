//
//  CUIImagePickerController.h
//
//  Created by Roman Cinis on 31.10.2022
//  Copyright 2022 Roman Cinis. All rights reserved.
//

#import "CUIImagePickerController.h"

// Implementation of the [CUIImagePickerController] class.
@implementation CUIImagePickerController

// [shouldAutorotate] is depricated on iOS 16+, but is used for in older systems.
- (BOOL)shouldAutorotate {
  return NO;
}

// Same as [shouldAutorotate] it's depricated on iOS 16+, but is used for in older systems.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationLandscapeLeft
         || interfaceOrientation != UIInterfaceOrientationLandscapeRight);
}


// The interface orientations that the view controller supports.
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskLandscape;
}


// The prefered orientation to use in camera view (default to landscape left)
// View will be rotated to this one if it's not in landscape already.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return UIInterfaceOrientationLandscapeLeft;
}

- (void)hideCameraOverlay {
    [self.cameraOverlayView setHidden:YES];
}

- (void)showCameraOverlay {
    [self.cameraOverlayView setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.sourceType != UIImagePickerControllerSourceTypeCamera) return;
    if (self.cameraOverlayView.isHidden) return;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(notificationReceived:)
                                          name:nil
                                          object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
 if (![[self.navigationController viewControllers] containsObject: self]) {
        NSLog(@"Unregistred observer");
        // The view has been removed from the navigation stack or hierarchy.
        [[NSNotificationCenter defaultCenter] removeObserver: self];
    }
}


- (void)notificationReceived:(NSNotification *)notification {
    // When pressed on the camera button to take a picture it will add a slight delay to
    // remove the lagg of taking away the overlay view.
    if ([notification.name isEqualToString:@"Recorder_WillCapturePhoto"]) {
        [self performSelector:@selector(hideCameraOverlay) withObject:nil afterDelay:0.1];
    }

    // When photo is shot, overlay should not be presented in the preview mode.
    if ([notification.name isEqualToString:@"_UIImagePickerControllerUserDidCaptureItem"]) {
        [self hideCameraOverlay];
    }

    // If user rejected the previewed photo, it will show the camera overlay again
    if ([notification.name isEqualToString:@"_UIImagePickerControllerUserDidRejectItem"]) {
        [self showCameraOverlay];
    }

    // Application is closing, hide overlay to prevent it covering anything else.
    if ([notification.name isEqualToString:@"UIApplicationSuspendedNotification"]) {
        [self hideCameraOverlay];
    }
}

@end
