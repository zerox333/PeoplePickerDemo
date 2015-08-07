//
//  ContactsPickerView.m
//  Diange
//
//  Created by ZeroX on 14/12/24.
//  Copyright (c) 2014年 ZeroX. All rights reserved.
//

#import "ContactsPickerView.h"
#import "UIView+Size.h"
#import "UIImage+Color.h"
#import "UIColor+Hex.h"

@interface ContactButton : UIButton

@end

@implementation ContactButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super titleRectForContentRect:contentRect];
    if (self.state == UIControlStateSelected) rect.origin.x = 5;
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super imageRectForContentRect:contentRect];
    if (self.state == UIControlStateSelected) rect.origin.x = contentRect.size.width - rect.size.width;
    return rect;
}

@end

@interface ContactsPickerView ()

@property(nonatomic, strong) NSMutableArray *buttons;
@property(nonatomic, weak) UIButton *selectedButton;

@end

@implementation ContactsPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _pickerContentInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        _font = [UIFont systemFontOfSize:13];
        self.showsHorizontalScrollIndicator = NO;
        _buttons = [NSMutableArray array];
    }
    return self;
}

- (void)reloadData
{
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_buttons removeAllObjects];
    for (int i = 0; i < [_dataSource numberOfContactsInContactsPickerView:self]; i++)
    {
        [self insertContactAtIndex:i animated:NO completion:NULL];
    }
}

- (ContactButton *)createButtonAtIndex:(NSUInteger)index
{
    CGFloat x = index > 0 ? [_buttons[index-1] right] + 5 : _pickerContentInsets.left;
    NSString *contactName = [_dataSource contactsPickerView:self contactNameAtIndex:index];
    CGFloat width = [contactName sizeWithAttributes:@{NSFontAttributeName:_font}].width;
    ContactButton *contactButton = [[ContactButton alloc] initWithFrame:CGRectMake(x, _pickerContentInsets.top, width + 25, 24)];
    contactButton.clipsToBounds = YES;
    contactButton.layer.cornerRadius = contactButton.height / 2;
    contactButton.titleLabel.font = _font;
    [contactButton setTitle:contactName forState:UIControlStateNormal];
    [contactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contactButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x06CB8D]] forState:UIControlStateNormal];
    [contactButton setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [contactButton setImage:[UIImage imageNamed:@"contact_delete"] forState:UIControlStateSelected];
    [contactButton addTarget:self action:@selector(contactButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    contactButton.tag = index;
    
    return contactButton;
}

- (void)insertContactAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    ContactButton *buttonToInsert = [self createButtonAtIndex:index];
    buttonToInsert.alpha = 0;
    [self insertSubview:buttonToInsert atIndex:index];
    [_buttons insertObject:buttonToInsert atIndex:index];
    void (^block)(void) = ^void(void) {
        buttonToInsert.alpha = 1;
        for (int i = (int)index + 1; i < _buttons.count; i++)
        {
            ContactButton *button = _buttons[i];
            button.left += button.width + 5;
            button.tag++;
        }
        self.contentSize = CGSizeMake([_buttons.lastObject right] + _pickerContentInsets.right, self.height);
        if (self.contentSize.width > self.width) self.contentOffset = CGPointMake(self.contentSize.width - self.width, self.contentOffset.y);
    };
    if (animated)
    {
        [UIView animateWithDuration:0.15 animations:block completion:completion];
    }
    else
    {
        block();
        if (completion) completion(YES);
    }
}

- (void)deleteContactAtIndex:(NSUInteger)index animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    ContactButton *buttonToDelete = _buttons[index];
    [_buttons removeObjectAtIndex:index];
    CGFloat width = buttonToDelete.width;
    void (^block)(void) = ^void(void) {
        buttonToDelete.alpha = 0;
        for (int i = (int)index; i < _buttons.count; i++)
        {
            UIButton *button = _buttons[i];
            button.left -= width + 5;
            button.tag--;
        }
        self.contentSize = CGSizeMake([_buttons.lastObject right] + _pickerContentInsets.right, self.height);
    };
    if (animated)
    {
        [UIView animateWithDuration:0.15 animations:block completion:^(BOOL finished) {
            [buttonToDelete removeFromSuperview];
            if (completion) completion(finished);
        }];
    }
    else
    {
        block();
        [_buttons[index] removeFromSuperview];
        if (completion) completion(YES);
    }
}

- (void)setPickerContentInsets:(UIEdgeInsets)pickerContentInsets
{
    _pickerContentInsets = pickerContentInsets;
    if ([_dataSource numberOfContactsInContactsPickerView:self] > 0) [self reloadData];
}

- (void)contactButtonTapped:(UIButton *)sender
{
    if (sender != _selectedButton) _selectedButton.selected = NO;
    if (sender.selected)
    {
        id<ContactsPickerViewDelegate> delegate = (id<ContactsPickerViewDelegate>)self.delegate;
        if ([delegate respondsToSelector:@selector(contactsPickerView:didDeleteContactAtIndex:)])
        {
            [delegate contactsPickerView:self didDeleteContactAtIndex:sender.tag];
        }
    }
    else
    {
        sender.selected = YES;
        _selectedButton = sender;
    }
}

@end
