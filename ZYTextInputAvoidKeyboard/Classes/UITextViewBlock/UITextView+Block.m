//
//  UITextView+Block.m
//  框架
//
//  Created by mayanwei on 14-9-4.
//  Copyright (c) 2014年 mayanwei. All rights reserved.
//

#import "UITextView+Block.h"
#import <objc/runtime.h>

@interface TextViewInternalDelegate : NSObject <UITextViewDelegate>

@property (nonatomic, copy) BOOL (^shouldBeginEditingBlock)(UITextView *textView);
@property (nonatomic, copy) BOOL (^shouldEndEditingBlock)(UITextView *textView);
@property (nonatomic, copy) void (^didBeginEditingBlock)(UITextView *textView);
@property (nonatomic, copy) void (^didEndEditingBlock)(UITextView *textView);
@property (nonatomic, copy) BOOL (^shouldChangeTextInRangeBlock)(UITextView *textView, NSRange range, NSString *replacementText);
@property (nonatomic, copy) void (^didChangeBlock)(UITextView *textView);
@property (nonatomic, copy) void (^didChangeSelectionBlock)(UITextView *textView);
@property (nonatomic, copy) BOOL (^shouldInteractWithURLBlock)(UITextView *textView, NSURL *URL, NSRange characterRange);
@property (nonatomic, copy) BOOL (^shouldInteractWithTextAttachmentBlock)(UITextView *textView, NSTextAttachment *textAttachment, NSRange characterRange);

@end

@implementation TextViewInternalDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    BOOL shouldBeginEditing = YES;
    if (self.shouldBeginEditingBlock) {
        shouldBeginEditing = self.shouldBeginEditingBlock(textView);
    }
    return shouldBeginEditing;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    BOOL shouldEndEditing = YES;
    if (self.shouldEndEditingBlock) {
        shouldEndEditing = self.shouldEndEditingBlock(textView);
    }
    return shouldEndEditing;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.didBeginEditingBlock) {
        self.didBeginEditingBlock(textView);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.didEndEditingBlock) {
        self.didEndEditingBlock(textView);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL shouldChangeCharacters = YES;
    if (self.shouldChangeTextInRangeBlock) {
        shouldChangeCharacters = self.shouldChangeTextInRangeBlock(textView, range, text);
    }
    return shouldChangeCharacters;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.didChangeBlock) {
        self.didChangeBlock(textView);
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (self.didChangeSelectionBlock) {
        self.didChangeSelectionBlock(textView);
    }
    return;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    BOOL shouldInteract = YES;
    if (self.shouldInteractWithURLBlock) {
        shouldInteract = self.shouldInteractWithURLBlock(textView, URL, characterRange);
    }
    return shouldInteract;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    BOOL shouldInteract = YES;
    if (self.shouldInteractWithTextAttachmentBlock) {
        shouldInteract = self.shouldInteractWithTextAttachmentBlock(textView, textAttachment, characterRange);
    }
    return shouldInteract;
}

@end

@implementation UITextView (Block)

static const void *TextViewInternalDelegateKey = &TextViewInternalDelegateKey;

- (TextViewInternalDelegate *)internalDelegate
{
    id delegate = [self delegate];
    if (delegate == nil) {
        TextViewInternalDelegate *internalDelegate = [[TextViewInternalDelegate alloc] init];
        objc_setAssociatedObject(self, TextViewInternalDelegateKey, internalDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self setDelegate:internalDelegate];
        delegate = internalDelegate;
    }
    
    if ([delegate isKindOfClass:[TextViewInternalDelegate class]] == NO) {
        delegate = nil;
    }
    return delegate;
}

- (void)shouldBeginEditing:(BOOL (^)(UITextView *textView))block
{
    TextViewInternalDelegate *internalDelegate = [self internalDelegate];
    [internalDelegate setShouldBeginEditingBlock:block];
}

- (void)shouldEndEditing:(BOOL (^)(UITextView *textView))block
{
    TextViewInternalDelegate *internalDelegate = [self internalDelegate];
    [internalDelegate setShouldEndEditingBlock:block];
}

- (void)didBeginEditing:(void (^)(UITextView *textView))block
{
    TextViewInternalDelegate *internalDelegate = [self internalDelegate];
    [internalDelegate setDidBeginEditingBlock:block];
}

- (void)didEndEditing:(void (^)(UITextView *textView))block
{
    TextViewInternalDelegate *internalDelegate = [self internalDelegate];
    [internalDelegate setDidEndEditingBlock:block];
}

- (void)shouldChangeTextInRange:(BOOL (^)(UITextView *textView, NSRange range, NSString *replacementText))block
{
    TextViewInternalDelegate *internalDelegate = [self internalDelegate];
    [internalDelegate setShouldChangeTextInRangeBlock:block];
}

- (void)didChange:(void (^)(UITextView *textView))block
{
    TextViewInternalDelegate *internalDelegate = [self internalDelegate];
    [internalDelegate setDidChangeBlock:block];
}

- (void)didChangeSelection:(void (^)(UITextView *textView))block
{
    TextViewInternalDelegate *internalDelegate = [self internalDelegate];
    [internalDelegate setDidChangeSelectionBlock:block];
}

- (void)shouldInteractWithURL:(BOOL (^)(UITextView *textView, NSURL *URL, NSRange characterRange))block
{
    TextViewInternalDelegate *internalDelegate = [self internalDelegate];
    [internalDelegate setShouldInteractWithURLBlock:block];
}

- (void)shouldInteractWithTextAttachment:(BOOL (^)(UITextView *textView, NSTextAttachment *textAttachment, NSRange characterRange))block
{
    TextViewInternalDelegate *internalDelegate = [self internalDelegate];
    [internalDelegate setShouldInteractWithTextAttachmentBlock:block];
}

@end
