//
//  ContactsSearchBar.m
//  Diange
//
//  Created by ZeroX on 14/12/23.
//  Copyright (c) 2014年 ZeroX. All rights reserved.
//

#import "ContactsSearchBar.h"
#import "UIView+Size.h"

static const CGFloat textFieldMinimumWidth = 140;

@interface ContactsSearchBar ()

@end

@implementation ContactsSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:ContactsSearchBarStylePeoplePicker];
}

- (instancetype)initWithFrame:(CGRect)frame style:(ContactsSearchBarStyle)style
{
    if (self = [super initWithFrame:frame])
    {
        self.textField.enablesReturnKeyAutomatically = NO;
        
        UIImageView *searchBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        BOOL alternative = (style == ContactsSearchBarStyleContactsBirthday);
        searchBarBackground.image = [[UIImage imageNamed:(alternative ? @"search_bar_background_alternative" : @"search_bar_background")] resizableImageWithCapInsets:UIEdgeInsetsMake(0, alternative ? 30 : 20, 0, alternative ? 30 : 20) resizingMode:UIImageResizingModeStretch];
        [self insertSubview:searchBarBackground atIndex:0];
        
        ContactsPickerView *contactsPickerView = [[ContactsPickerView alloc] initWithFrame:CGRectMake(15, 0, 0, self.height)];
        [self addSubview:contactsPickerView];
        _contactsPickerView = contactsPickerView;
        
        self.textField.frame = CGRectMake(25, 0, self.width - contactsPickerView.right - 20, self.height);
        self.textField.background = nil;
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.textColor = [UIColor blackColor];
        self.textField.tintColor = [UIColor lightGrayColor];
        self.textField.attributedPlaceholder = nil;
        self.textField.placeholder = @"手机号/拼音";
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        self.textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
    }
    return self;
}

- (void)reloadData
{
    [_contactsPickerView reloadData];
    [self adjustsSubviews];
}

- (void)insertContactAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    [_contactsPickerView insertContactAtIndex:index animated:animated completion:completion];
    [self adjustsSubviews];
}

- (void)deleteContactAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    [_contactsPickerView deleteContactAtIndex:index animated:animated completion:completion];
    [self adjustsSubviews];
}

- (void)adjustsSubviews
{
    [UIView animateWithDuration:0.15 animations:^{
        _contactsPickerView.width = MIN(_contactsPickerView.contentSize.width, self.width - textFieldMinimumWidth);
        self.textField.left = _contactsPickerView.right + 10;
        self.textField.width = self.width - _contactsPickerView.right - 20;
    }];
}

@end
