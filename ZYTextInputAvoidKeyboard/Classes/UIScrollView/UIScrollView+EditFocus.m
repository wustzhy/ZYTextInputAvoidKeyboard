//
//  UIScrollView+EditFocus.m
//  滑动列表中的textView，在输入状态下 随键盘联动
//
//  Created by yestin on 2018/10/13.
//  Copyright © 2018年 yestin. All rights reserved.
//

#import "UIScrollView+EditFocus.h"
#import <objc/runtime.h>
#import <KVOController/KVOController.h>
#import "UITextView+Block.h"

// 来自YYKit
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

// 横屏判断
#define IS_LANDSCAPE (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
// 屏幕高度
#define SCREEN_HEIGHT (IS_LANDSCAPE ? [[UIScreen mainScreen ] bounds].size.width : [[UIScreen mainScreen ] bounds].size.height)

static __weak id currentFirstResponder;
@interface UIResponder (FirstResponder)
+ (id)getCurrentFirstResponder;
@end
@implementation UIResponder (FirstResponder)
+ (id)getCurrentFirstResponder
{
    currentFirstResponder = nil;
    // 通过将target设置为nil，让系统自动遍历响应链
    // 从而响应链当前第一响应者响应我们自定义的方法
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    return currentFirstResponder;
}
- (void)findFirstResponder:(id)sender
{
    // 第一响应者会响应这个方法，并且将静态变量currentFirstResponder设置为自己
    currentFirstResponder = self;
    //    NSLog(@"findFirstResponder---%@", self);
}
@end


#pragma mark -
#pragma mark -

@implementation UIScrollView (AutoAdjustWhileEdit)


-(void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview == nil) {
        [self.KVOControllerNonRetaining unobserve:self];
    }
}

#pragma mark - Public
static NSString * const kAutoAdjustSwitchKey = @"AutoAdjustSwitchKey";
- (void)setIsAutoAdjust:(BOOL)isAutoAdjust
{
    objc_setAssociatedObject(self, &kAutoAdjustSwitchKey, @(isAutoAdjust), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (isAutoAdjust) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    }
    
    @weakify(self);
    [self.KVOControllerNonRetaining observe:self keyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            CGPoint new = [change[NSKeyValueChangeNewKey] CGPointValue];
            NSLog(@" kvo offY ------- %@", NSStringFromCGPoint(new));
            [self setLastOffsetY:@(new.y)];
        });
        
    }];
}
- (BOOL)isAutoAdjust
{
    return [objc_getAssociatedObject(self, &kAutoAdjustSwitchKey) boolValue];
}

static const void *kBottomMarginKey = @"kBottomMarginKey";
- (void)setInputViewBottomMargin:(CGFloat)bottomMargin
{
    objc_setAssociatedObject(self, kBottomMarginKey, @(bottomMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)inputViewBottomMargin
{
    return [objc_getAssociatedObject(self, kBottomMarginKey) floatValue];
}

static NSString * const kKeyboardShowKey = @"KeyboardShowKey";
- (void)setIsKeyboardShow:(BOOL)isKeyboardShow
{
    objc_setAssociatedObject(self, &kKeyboardShowKey, @(isKeyboardShow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isKeyboardShow
{
    return [objc_getAssociatedObject(self, &kKeyboardShowKey) boolValue];
}

static const void *kIsCursorAlignKey = @"kIsCursorAlignKey";
- (void)setIsCursorAlign:(BOOL)isCursorAlign
{
    objc_setAssociatedObject(self, kIsCursorAlignKey, @(isCursorAlign), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)isCursorAlign
{
    return [objc_getAssociatedObject(self, kIsCursorAlignKey) boolValue];
}

static const void *kOriginalContentInsetBottomKey = @"kOriginalContentInsetBottomKey";
- (void)setOriginalContentInsetBottom:(NSNumber *)originalContentInsetBottom
{
    objc_setAssociatedObject(self, kOriginalContentInsetBottomKey, originalContentInsetBottom, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)originalContentInsetBottom
{
    return objc_getAssociatedObject(self, kOriginalContentInsetBottomKey);
}

static const void *kLastOffsetYKey = @"kLastOffsetYKey";

- (void)setLastOffsetY:(NSNumber *)lastOffsetY
{
    NSLog(@" ------- setLastOffsetY: %@", lastOffsetY);
    objc_setAssociatedObject(self, kLastOffsetYKey, lastOffsetY, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)lastOffsetY
{
    return objc_getAssociatedObject(self, kLastOffsetYKey);
}


#pragma mark - Private
static const void *kkeyBoardHeightKey = @"kkeyBoardHeightKey";
- (void)setKeyBoardHeight:(CGFloat)keyBoardHeight
{
    objc_setAssociatedObject(self, kkeyBoardHeightKey, @(keyBoardHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)keyBoardHeight
{
    return [objc_getAssociatedObject(self, kkeyBoardHeightKey) floatValue];
}


/** 输入视图底部 对齐 键盘顶部, 所应调整的offsetY */
- (CGFloat)adjustContentOffsetyWithAlignInputView:(UIView *)inputView {
    
    CGRect inputViewFrame = [self convertRect:inputView.frame fromView:inputView.superview];
    CGFloat maxY = CGRectGetMaxY(inputViewFrame) + self.inputViewBottomMargin;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [keyWindow convertRect:self.frame fromView:self.superview];
    // scrollView 距屏幕底部的间距
    CGFloat bottomMarge = keyWindow.frame.size.height - CGRectGetMaxY(selfRect);
    
    // 会被遮挡的高度
    CGFloat coverHeight = [self keyBoardHeight] - bottomMarge;
    // 要完全显示时需要调整的 contentOffset y
    CGFloat adjustContentOffsetY = coverHeight + maxY - self.frame.size.height;
    
    return adjustContentOffsetY;
}

/** 输入视图「光标」 对齐 键盘顶部, 所应调整的offsetY */
- (void)adjustContentOffsetyWithAlignTextView:(UITextView *)textView isTextChange:(BOOL)isTextChange{
    
    CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.end];
    NSLog(@" ------- textView Selection: %@", @(caretRect.origin.y));
    
    CGRect rectInWindow = [textView convertRect:caretRect toView:nil];
    
    NSLog(@" ------- rectInWindow: %@", NSStringFromCGRect(rectInWindow));
    NSLog(@" ------- keyBoardHeight: %@", @([self keyBoardHeight]));
    NSLog(@" ------- result: %@", @(SCREEN_HEIGHT - [self keyBoardHeight] - CGRectGetMaxY(rectInWindow)));
    NSLog(@" ------- self.contentOffset.y: %f", self.contentOffset.y);
    NSLog(@" ------- [self lastOffsetY]: %@", [self lastOffsetY]);
    
    if (CGRectGetMaxY(rectInWindow) <= SCREEN_HEIGHT - [self keyBoardHeight]) {
        
        if (isTextChange == NO) {
            //若不调用词句，查看堆栈会自动调用[UIScrollViewScrollAnimation setProgress:],导致切换输入框时会调setContentOffset:,使
            [self setContentOffset:CGPointMake(0, [self lastOffsetY].floatValue) animated:NO];
            if ([self respondsToSelector:@selector(setTempSetOffsetDisable:)]) {
              [self setValue:@(YES) forKey:@"tempSetOffsetDisable"];
            }
        }
        return;
    }
    
    CGFloat adjustContentOffsetY = [self keyBoardHeight] + CGRectGetMaxY(rectInWindow) - SCREEN_HEIGHT;
    
    NSLog(@" ------- adjustContentOffsetY: %@", @(adjustContentOffsetY));
    
    CGFloat minOffsetY = - self.contentInset.top;
    if (adjustContentOffsetY > minOffsetY) {
        CGFloat destOffY = [self lastOffsetY].floatValue + adjustContentOffsetY;
        [self setContentOffset:CGPointMake(0, destOffY) animated:NO];
      if ([self respondsToSelector:@selector(setTempSetOffsetDisable:)]) {
        [self setValue:@(YES) forKey:@"tempSetOffsetDisable"];
      }
    }
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)notice
{
    if (!self.isAutoAdjust) return;
    
    if (currentFirstResponder) {
        [self.KVOController unobserve:currentFirstResponder keyPath:@"frame"];
    }
    
    NSValue *aValue = [notice.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeigth = keyboardRect.size.height;
    [self setKeyBoardHeight:keyboardHeigth];
    
    UIView *textField = [UIResponder getCurrentFirstResponder];
    if (![textField isKindOfClass:[UIView class]]) return;
    
    //    if (self.originalContentInsetBottom) {
    //        UIEdgeInsets inset = self.contentInset;
    //        inset.bottom = [self.originalContentInsetBottom floatValue] + keyboardHeigth;
    //        self.contentInset = inset;
    //    }
    
    //判断光标 是否会被移出可视范围内
    if([textField isKindOfClass:[UITextView class]] &&
       self.isCursorAlign == YES) {
        
        UITextView *textV = (UITextView *)textField;
        
        @weakify(self);
        // 解决didChangeSelection没有涵盖的一种情况：点击的位置 与 上次光标所在位置一样时
        [textV didBeginEditing:^(UITextView *textView) {
            @strongify(self);
            NSLog(@" ------- didBeginEditing:%@",textView);
            NSLog(@" ------- self.contentOffset.y: %f", self.contentOffset.y);
            NSLog(@" ------- [self lastOffsetY]: %@", [self lastOffsetY]);
            [self performSelector:@selector(adjustContentOffsetyWithAlignTextView:isTextChange:) withObject:textView afterDelay:0.1];
        }];
        
        // 点击的位置 与 上次光标所在位置不一样时
        [textV didChangeSelection:^(UITextView *textView) {
            @strongify(self);
            NSLog(@" ------- didChangeSelection:%@",textView);
            NSLog(@" ------- self.contentOffset.y: %f", self.contentOffset.y);
            NSLog(@" ------- [self lastOffsetY]: %@", [self lastOffsetY]);
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(adjustContentOffsetyWithAlignTextView:isTextChange:) object:textView];
            [self adjustContentOffsetyWithAlignTextView:textView isTextChange:NO];
        }];
        
    }else {
        CGFloat adjustContentOffsetY = [self adjustContentOffsetyWithAlignInputView:textField];
        
        CGFloat minOffsetY = - self.contentInset.top;
        if (adjustContentOffsetY > minOffsetY) {
            [self setContentOffset:CGPointMake(0, adjustContentOffsetY) animated:NO];
        }
    }
    
}

- (void)keyboardDidShow:(NSNotification *)note
{
    self.isKeyboardShow = YES;
    
    if (!self.isAutoAdjust) return;
    
    if (currentFirstResponder) {
        @weakify(self);
        [self.KVOController observe:currentFirstResponder keyPath:NSStringFromSelector(@selector(frame)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
            @strongify(self);
            NSValue *new = change[NSKeyValueChangeNewKey];
            NSValue *old = change[NSKeyValueChangeOldKey];
            CGRect new_bounds = [new CGRectValue];
            CGRect old_bounds = [old CGRectValue];
            if (CGRectEqualToRect(new_bounds, old_bounds)) {
                return ;
            }
            
            if (self.isKeyboardShow) {
                
                UIView *textField = [UIResponder getCurrentFirstResponder];
                if (![textField isKindOfClass:[UIView class]]) return;
                
                CGFloat currentOffsetY = self.contentOffset.y;
                NSLog(@" -------currentOffsetY: %f", currentOffsetY);
                NSLog(@" ------- [self lastOffsetY]: %@", [self lastOffsetY]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    CGFloat adjustContentOffsetY = new_bounds.size.height - old_bounds.size.height;
                    NSLog(@" -------frame ---- adjustContentOffsetY: %f", adjustContentOffsetY);
                    
                    if (adjustContentOffsetY > 0) {
                        CGFloat destOffY = currentOffsetY + adjustContentOffsetY;
                        [self setContentOffset:CGPointMake(0, destOffY) animated:NO];
                    }
                    //                    }
                    
                });
            }
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notice
{
    if (currentFirstResponder) {
        if ([currentFirstResponder isKindOfClass:[UITextView class]] &&
            self.isCursorAlign == YES) {
            [(UITextView *)currentFirstResponder didBeginEditing:nil];
            [(UITextView *)currentFirstResponder didChangeSelection:nil];
        }
    }
    
    if (!self.isAutoAdjust) return;
    
    //    if (self.originalContentInsetBottom) {
    //        UIEdgeInsets inset = self.contentInset;
    //        inset.bottom = [self.originalContentInsetBottom floatValue];
    //        self.contentInset = inset;
    //    }
    
    if (self.contentSize.height < self.frame.size.height) return;
    
    if (self.contentOffset.y > self.contentSize.height - self.frame.size.height) {
        [self setContentOffset:CGPointMake(0, self.contentSize.height - self.frame.size.height) animated:YES];
    }
    
}

- (void)keyboardDidHide:(NSNotification *)note
{
    self.isKeyboardShow = NO;
    self.inputViewBottomMargin = 0;
}


@end
