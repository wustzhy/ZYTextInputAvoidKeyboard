//
//  UITextView+Block.h
//  框架
//
//  Created by mayanwei on 14-9-4.
//  Copyright (c) 2014年 mayanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Block)

- (void)shouldBeginEditing:(BOOL (^)(UITextView *textView))block;
- (void)shouldEndEditing:(BOOL (^)(UITextView *textView))block;
- (void)didBeginEditing:(void (^)(UITextView *textView))block;
- (void)didEndEditing:(void (^)(UITextView *textView))block;
- (void)shouldChangeTextInRange:(BOOL (^)(UITextView *textView, NSRange range, NSString *replacementText))block;
- (void)didChange:(void (^)(UITextView *textView))block;
- (void)didChangeSelection:(void (^)(UITextView *textView))block;
- (void)shouldInteractWithURL:(BOOL (^)(UITextView *textView, NSURL *URL, NSRange characterRange))block;
- (void)shouldInteractWithTextAttachment:(BOOL (^)(UITextView *textView, NSTextAttachment *textAttachment, NSRange characterRange))block;

@end
