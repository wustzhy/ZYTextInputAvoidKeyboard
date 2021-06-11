//
//  NSAttributedString+Calculate.m
//  deepLeaper
//
//  Created by yestin on 2019/12/27.
//  Copyright © 2019 dler. All rights reserved.
//

#import "NSAttributedString+Calculate.h"

@implementation NSAttributedString (Calculate)

- (CGSize)sizeWitMaxW:(CGFloat)maxW numberOfLines:(NSUInteger)numberOfLines;
{
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = numberOfLines;
    label.attributedText = self;
    CGFloat titleHeight = [label sizeThatFits:CGSizeMake(maxW, MAXFLOAT)].height;
    return CGSizeMake(maxW, titleHeight);
    
}


@end
