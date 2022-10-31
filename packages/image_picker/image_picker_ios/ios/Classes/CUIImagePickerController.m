//
//  CUIImagePickerController.h
//
//  Created by Roman Cinis on 31.10.2022
//  Copyright 2022 Roman Cinis. All rights reserved.
//

// Basic import to inherit from [UIImagePickerController] class.
#import "CUIImagePickerController.h"

@implementation CUIImagePickerController
- (BOOL)shouldAutorotate {
  return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return UIInterfaceOrientationPortrait;
}

@end
