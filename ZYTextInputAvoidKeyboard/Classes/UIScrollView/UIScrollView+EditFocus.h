//
//  UIScrollView+EditFocus.h
//  滑动列表中的textView，在输入状态下 随键盘联动
//
//  Created by yestin on 2018/10/13.
//  Copyright © 2018年 yestin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (AutoAdjustWhileEdit)

@property (nonatomic, assign) BOOL isAutoAdjust;

/**
 场景：不以可输入的view 定位, ex:距离keyboard顶部bottomMargin位置 定位 textView
 每次begin editting前，设置 inputViewBottomMargin; inputViewBottomMargin会在键盘收起后置0  */
@property (nonatomic, assign) CGFloat inputViewBottomMargin;

@property (nonatomic, assign, readonly) BOOL isKeyboardShow;


/** 当键盘弹起时，使用光标 对齐 键盘顶部方式。
    默认是，输入视图底部 对齐 键盘顶部 */
@property (nonatomic, assign) BOOL isCursorAlign;
//ex:评论，使用 textView底部 对齐 键盘顶部
//ex:图文视频编辑页，使用 光标底部 对齐 键盘顶部

/** textView需要高度自适应时 */
@property (nonatomic, assign) NSNumber *originalContentInsetBottom;//存在则 曾设置过
@end
