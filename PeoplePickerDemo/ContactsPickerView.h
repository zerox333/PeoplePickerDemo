//
//  ContactsPickerView.h
//  Diange
//
//  Created by ZeroX on 14/12/24.
//  Copyright (c) 2014年 ZeroX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactOperation <NSObject>

- (void)reloadData;
- (void)insertContactAtIndex:(NSUInteger)index
                    animated:(BOOL)animated
                  completion:(void (^)(BOOL finished))completion;
- (void)deleteContactAtIndex:(NSUInteger)index
                    animated:(BOOL)animated
                  completion:(void (^)(BOOL finished))completion;

@end

@class ContactsPickerView;

@protocol ContactsPickerViewDataSource <NSObject>

- (NSInteger)numberOfContactsInContactsPickerView:(ContactsPickerView *)contactsPickerView;
- (NSString *)contactsPickerView:(ContactsPickerView *)contactsPickerView contactNameAtIndex:(NSUInteger)index;

@end

@protocol ContactsPickerViewDelegate <UIScrollViewDelegate>

@optional

- (void)contactsPickerView:(ContactsPickerView *)contactsPickerView didDeleteContactAtIndex:(NSUInteger)index;

@end

@interface ContactsPickerView : UIScrollView <ContactOperation>

@property(nonatomic) UIEdgeInsets pickerContentInsets;
@property(nonatomic) UIFont *font;
@property(nonatomic, weak) id<ContactsPickerViewDataSource> dataSource;

@end
