//
//  CHTextView.m
//  deepLeaper
//
//  Created by yestin on 2019/12/3.
//  Copyright © 2019 dler. All rights reserved.
//

#import "CHTextView.h"
#import "UITextView+Block.h"
#import "UITextView+Placeholder.h"
#import "GlobalDefines.h"


@interface CHTextView ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGFloat viewHeight;
@end

@implementation CHTextView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        @weakify(self);
        [self didChange:^(UITextView *textView) {
            @strongify(self);
            
            if (self.maxTextNum) {
                //在没有候选词的时候进行截取
                if(textView.markedTextRange ==nil){
                    //    记录光标位置
                    NSRange rang = textView.selectedRange;
                    if(textView.text.length > self.maxTextNum.integerValue){
                        textView.text = [textView.text substringToIndex:self.maxTextNum.integerValue];
                    }
                    //截取后还原光标位置
                    textView.selectedRange =rang;
                    [textView scrollRangeToVisible:rang];
                }
            }
            
            if (self.textChangedBlock) {
                self.textChangedBlock(textView.text);
            }

            CGRect textFrame=[[self layoutManager]usedRectForTextContainer:[self textContainer]];
            CGFloat height = textFrame.size.height;
            CGFloat result = MAX(10 + height, 44);
            
            self.viewHeight = result;
        }];
        
    }
    return self;
}


-(void)setViewHeight:(CGFloat)viewHeight {
    
    if (_viewHeight != viewHeight) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.contentOffset = CGPointZero;
        });
        
        if (self.heightChangedBlock) {
            self.heightChangedBlock(viewHeight);
        }
    }
    _viewHeight = viewHeight;
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return !self.recognizeSimultaneouslyDisable;
    
}

@end
