//
//  CHTextView.h
//  deepLeaper
//
//  Created by yestin on 2019/12/3.
//  Copyright © 2019 dler. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FloatBlock)(CGFloat value);
typedef void (^StringBlock)(NSString *string);


@interface CHTextView : UITextView

@property (nonatomic, copy) FloatBlock heightChangedBlock;
@property (nonatomic, copy) StringBlock textChangedBlock;

@property (nonatomic, strong) NSNumber *maxTextNum;

@property (nonatomic, assign) BOOL recognizeSimultaneouslyDisable; //禁止滑动穿透(父view同时滑)
@end

