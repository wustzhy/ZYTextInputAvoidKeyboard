//
//  ZYBaseTableView.m
//  test_keyboardFocus
//
//  Created by yestin on 2020/2/11.
//  Copyright © 2020 deepleaper. All rights reserved.
//

#import "ZYBaseTableView.h"

@implementation ZYBaseTableView

-(void)setTempLimitContentSizeH:(CGFloat)tempLimitContentSizeH {
    _tempLimitContentSizeH = tempLimitContentSizeH;
    [self performSelector:@selector(removeTempLimitContentSizeH) withObject:nil afterDelay:0.1];
}
- (void)removeTempLimitContentSizeH {
    _tempLimitContentSizeH = 0;
}

-(void)setTempSetOffsetDisable:(BOOL)tempSetOffsetDisable {
    _tempSetOffsetDisable = tempSetOffsetDisable;
    [self performSelector:@selector(removeTempSetOffsetDisable) withObject:nil afterDelay:1];
}
- (void)removeTempSetOffsetDisable {
    _tempSetOffsetDisable = NO;
}


-(void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    
    NSLog(@"will setContentOffset:animated: %@ ------- %@", @(animated), NSStringFromCGPoint(contentOffset));
    
    if (self.tempSetOffsetDisable) {
        return;
    }

    NSLog(@"did setContentOffset:animated: %@ ------- %@", @(animated), NSStringFromCGPoint(contentOffset));
    
    [super setContentOffset:contentOffset animated:animated];

    
}

-(void)setContentOffset:(CGPoint)contentOffset {
    
    NSLog(@"will setContentOffset: %@ ", @(contentOffset));
    
    if (self.tempSetOffsetDisable) {
        return;
    }
    
    NSLog(@"did setContentOffset: %@ ", @(contentOffset));
    
    [super setContentOffset:contentOffset];
}

-(void)setContentSize:(CGSize)contentSize {
    
    if (self.tempLimitContentSizeH > 0 &&
        (self.tempLimitContentSizeH - 10 > contentSize.height ||
         self.tempLimitContentSizeH + 10 < contentSize.height)) {
        return;
    }
    
    [super setContentSize:contentSize];
    
    NSLog(@"setContentSize: ------- %@", NSStringFromCGSize(contentSize));
}

@end
