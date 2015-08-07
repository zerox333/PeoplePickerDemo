//
//  ContactsSearchBar.h
//  Diange
//
//  Created by ZeroX on 14/12/23.
//  Copyright (c) 2014年 ZeroX. All rights reserved.
//

#import "SearchBar.h"
#import "ContactsPickerView.h"

typedef NS_ENUM(NSInteger, ContactsSearchBarStyle)
{
    ContactsSearchBarStylePeoplePicker = 0,
    ContactsSearchBarStyleContactsBirthday = 1,
};

@interface ContactsSearchBar : SearchBar <ContactOperation>

@property(nonatomic, readonly, weak) ContactsPickerView *contactsPickerView;

- (instancetype)initWithFrame:(CGRect)frame style:(ContactsSearchBarStyle)style;

@end
