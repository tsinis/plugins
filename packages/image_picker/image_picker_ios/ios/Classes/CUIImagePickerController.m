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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
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

@end
