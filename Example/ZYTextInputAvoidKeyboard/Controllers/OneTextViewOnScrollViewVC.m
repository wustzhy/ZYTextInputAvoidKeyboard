//
//  OneTextViewOnScrollViewVC.m
//  ZYTextInputAvoidKeyboard_Example
//
//  Created by yestinZhao on 2021/6/11.
//  Copyright © 2021 赵洋. All rights reserved.
//

#import "OneTextViewOnScrollViewVC.h"
#import "CHTextView.h"
#import "UITextView+Block.h"
#import "UITextView+Placeholder.h"
#import "NSAttributedString+Calculate.h"
#import "UIScrollView+EditFocus.h"
#import "GlobalDefines.h"

#define kMaxContentTextNum 10000

@interface OneTextViewOnScrollViewVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CHTextView *textView;
@end

@implementation OneTextViewOnScrollViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"单个textView";
    [self setNav];
    
    [self initView];
    
}

- (void)setNav {
    //自定义文字样式的左侧按钮
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = btnItem;
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)initView {
    
    [self.view addSubview:({
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 10);
        _scrollView = scrollView;
        scrollView = scrollView;
    })];
    
    [self.scrollView addSubview:self.textView];

    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.scrollView.isAutoAdjust = YES;
    self.scrollView.isCursorAlign = YES;
}


- (CGFloat)heightWithText:(NSString *)text {
    
    NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:text attributes:[self attributes]];
    CGFloat textWidth = self.textView.frame.size.width - self.textView.textContainer.lineFragmentPadding*2;
    CGFloat height = [attStr sizeWitMaxW:textWidth numberOfLines:0].height + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom;
    return height;
}

- (NSDictionary *)attributes {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 3;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return attributes;
}

- (void)changeHeightWithString:(NSString *)string {
    CGRect frame = self.textView.frame;
    frame.size.height = [self heightWithText:string];
    self.textView.frame = frame;
}

-(CHTextView *)textView {
    if (!_textView) {
        CHTextView *textView = [[CHTextView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 40)];
        textView.typingAttributes = [self attributes];
        
        [textView setPlaceholder:@"记录越详实，越能帮到大家"];
        [textView setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
        
//        @weakify(self);
//        [textView didBeginEditing:^(UITextView *textView) {
//            @strongify(self);
//            NSLog(@" ------- didBeginEditing");
//            [self textdidBeginEditing:textView];
//        }];
        
//        [textView didChangeSelection:^(UITextView *textView) {
//            @strongify(self);
//            NSLog(@" ------- didChangeSelection");
//            [self textdidBeginEditing:textView];
//        }];
        
        @weakify(self);
        [textView didChange:^(UITextView *textView) {
            @strongify(self);
            NSLog(@" ------- didChange");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeHeightWithString:textView.text];
            });
        }];
        
        textView.maxTextNum = @(kMaxContentTextNum);
        [textView shouldChangeTextInRange:^BOOL(UITextView *textView, NSRange range, NSString *replacementText) {
            
            if((replacementText.length == 0)&&(range.length == 1)){
                return YES;
            }
            NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:replacementText];
            if (comcatstr.length > kMaxContentTextNum) {
                NSLog(@" ------- %@", [NSString stringWithFormat:@"已达到%@字上限了哦~",@(kMaxContentTextNum)]);
            }
            return YES;
        }];
        
        _textView = textView;
        textView;
    }
    return _textView;
}


- (void)textdidBeginEditing:(UITextView*)textView {
    
    CGFloat cursorPosition;
    
    if (textView.selectedTextRange) {
        
        cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin.y;
        
    } else {
        
        cursorPosition =0;
    }
    NSLog(@" ------- cursor: %@", @(cursorPosition));
}


@end
