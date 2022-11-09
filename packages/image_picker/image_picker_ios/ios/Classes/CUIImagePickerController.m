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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
         || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


// The interface orientations that the view controller supports.
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}


// The prefered orientation to use in camera view (default to portrait)
// View will be rotated to this one if it's not in the portrait mode already.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return UIInterfaceOrientationPortrait;
}

- (void)hideCameraOverlay {
    [self.cameraOverlayView setHidden:YES];
}

- (void)showCameraOverlay {
    [self.cameraOverlayView setHidden:NO];
}

/// [self.cameraOverlayView.subviews.count] is only avalible at this moment.
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // [self.cameraOverlayView] is only avalible when [sourceType] is the camera.
    if (self.sourceType != UIImagePickerControllerSourceTypeCamera) return;
    // If camera overlay has some subviews -> it should be our [OverlayView].
    if (self.cameraOverlayView.subviews.count < 1) return;
    // So we have a camera overlay at this moment, let's show it after small delay.
    [self performSelector:@selector(showCameraOverlay) withObject:nil afterDelay:1.2];
    // And add notifications observer with a handler.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(notificationReceived:)
                                          name:nil
                                          object:nil];
}

// Remove notification observer if UI is being closed.
- (void)viewWillDisappear:(BOOL)animated{
    // Camera preview has to navigation routes.
 if (![[self.navigationController viewControllers] containsObject: self]) {
        // The view has been removed from the navigation stack or hierarchy.
        [[NSNotificationCenter defaultCenter] removeObserver: self];
        [[UIApplication sharedApplication] setStatusBarHidden: NO];
    }
}


// Notification observer, that will listen to a [NSNotification]s and perform actions accordingly.
- (void)notificationReceived:(NSNotification *)notification {
    // When pressed on the camera button to take a picture it will add a slight delay to
    // remove the lagg of taking navigation to the overlay view.
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
