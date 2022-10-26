//
//  OverlayView.h
//
//  Created by Roman Cinis on 25.10.2022
//  Copyright 2022 Roman Cinis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayView : UIView
- (id)initWithFrame:(CGRect)frame andPath:(NSString *)path andOpacity:(NSNumber *)opacity;

@property(assign, nonatomic) CGFloat offset;
@end
