# ZYTextInputAvoidKeyboard

[![CI Status](https://img.shields.io/travis/赵洋/ZYTextInputAvoidKeyboard.svg?style=flat)](https://travis-ci.org/赵洋/ZYTextInputAvoidKeyboard)
[![Version](https://img.shields.io/cocoapods/v/ZYTextInputAvoidKeyboard.svg?style=flat)](https://cocoapods.org/pods/ZYTextInputAvoidKeyboard)
[![License](https://img.shields.io/cocoapods/l/ZYTextInputAvoidKeyboard.svg?style=flat)](https://cocoapods.org/pods/ZYTextInputAvoidKeyboard)
[![Platform](https://img.shields.io/cocoapods/p/ZYTextInputAvoidKeyboard.svg?style=flat)](https://cocoapods.org/pods/ZYTextInputAvoidKeyboard)

## Example

To run the example project, you need to clone the repo, and run `pod install` from the Example directory first.

## Requirements

none

## Installation

ZYTextInputAvoidKeyboard is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZYTextInputAvoidKeyboard'
```

## Usage

```
// 是否光标所在视图与键盘联动, YES是
self.scrollView.isAutoAdjust = YES;

// 是否距离keyboard顶部bottomMargin位置 去定位输入框
self.scrollView.isCursorAlign = YES;

// 距离keyboard顶部bottomMargin位置 定位 textView
self.scrollView.inputViewBottomMargin = 10;
```
无论单个or多个textView在tableView/scrollView，都适用。


## Author

赵洋, zhaoyang@deepleaper.com

## License

ZYTextInputAvoidKeyboard is available under the MIT license. See the LICENSE file for more info.
