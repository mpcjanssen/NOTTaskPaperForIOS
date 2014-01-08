//
//  TitleBar.m
//  PlainText
//
//  Created by Jesse Grosjean on 6/23/10.
//  Copyright 2010 Hog Bay Software. All rights reserved.
//

#import "Titlebar.h"
#import "ApplicationController.h"
#import "PathViewWrapper.h"
#import "BrowserView.h"
#import "PathView.h"
#import "Button.h"


@implementation Titlebar

- (id)init {
	self = [super init];
    self.drawTopDivider = NO;
	self.drawBottomDivider = YES;
	return self;
}

@synthesize pathViewWrapper;

- (void)setPathViewWrapper:(PathViewWrapper *)aPathViewWrapper becomeFirstResponder:(BOOL)becomeFirstResponder {
	if (aPathViewWrapper) {		
		if (!aPathViewWrapper.pathView.accessibilityLabel) {
			aPathViewWrapper.pathView.accessibilityLabel = NSLocalizedString(@"Title", nil);
		}
		
		if (pathViewWrapper) {
			aPathViewWrapper.frame = pathViewWrapper.frame;
		}
		
		[self addSubview:aPathViewWrapper];
		if (becomeFirstResponder) {
			[aPathViewWrapper.pathView becomeFirstResponder];
			[aPathViewWrapper.pathView selectAllWithNoMenuController:nil];
		}
	}
	[pathViewWrapper removeFromSuperview];
	pathViewWrapper = aPathViewWrapper;
}

@synthesize leftButton;

- (void)setLeftButton:(UIButton *)aButton {
	[leftButton removeFromSuperview];
	leftButton = aButton;
	if (leftButton) {
		originalLeftWidth = leftButton.frame.size.width;
		originalLeftInsets = leftButton.imageEdgeInsets;
		[self layoutSubviews];
		[self addSubview:leftButton];
	}
}

@synthesize rightButton;

- (void)setRightButton:(UIButton *)aButton {
	[rightButton removeFromSuperview];
	rightButton = aButton;
	if (rightButton) {
		originalRightWidth = rightButton.frame.size.width;
		originalRightInsets = rightButton.imageEdgeInsets;
		[self layoutSubviews];
		[self addSubview:rightButton];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, padding);
	
	if (leftButton) {
		CGRect leftFrame = CGRectZero;
		UIEdgeInsets imageEdgeInsets = originalLeftInsets;
		CGRectDivide(bounds, &leftFrame, &bounds, originalLeftWidth, CGRectMinXEdge);
		leftFrame.origin.x = 0;
		leftFrame.size.width += padding.left;
		leftButton.frame = CGRectIntegral(leftFrame);
		imageEdgeInsets.left += padding.left;
		leftButton.imageEdgeInsets = imageEdgeInsets;
	}

	if (rightButton) {
		CGRect rightFrame = CGRectZero;
		UIEdgeInsets imageEdgeInsets = originalRightInsets;
		CGRectDivide(bounds, &rightFrame, &bounds, originalRightWidth, CGRectMaxXEdge);
		rightFrame.size.width += padding.right;
		rightFrame.origin.x = CGRectGetMaxX(self.bounds) - rightFrame.size.width;
		rightButton.frame = CGRectIntegral(rightFrame);
		imageEdgeInsets.right += padding.right;
		rightButton.imageEdgeInsets = imageEdgeInsets;
	}
	
	CGFloat leftWidth = leftButton != nil ? originalLeftWidth : 0;
	CGFloat rightWidth = rightButton != nil ? originalRightWidth : 0;
	CGFloat maxWidth = 0;
	
	if (leftWidth > rightWidth) {
		maxWidth = leftWidth;
	} else {
		maxWidth = rightWidth;
	}
	
	if (maxWidth == 0) {
		maxWidth = 32;
	}
		
	CGRect pathViewWrapperFrame = UIEdgeInsetsInsetRect(self.bounds, padding);
	pathViewWrapperFrame = CGRectInset(pathViewWrapperFrame, maxWidth, 0);
	pathViewWrapper.frame = CGRectIntegral(pathViewWrapperFrame);
}

@end
