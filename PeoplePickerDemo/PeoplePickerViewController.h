//
//  PeoplePickerViewController.h
//  Diange
//
//  Created by ZeroX on 14/12/19.
//  Copyright (c) 2014年 ZeroX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PeoplePickerViewController;

@protocol PeoplePickerViewControllerDelegate <NSObject>

@optional

- (void)peoplePickerViewController:(PeoplePickerViewController *)peoplePickerViewController
                 didSelectContacts:(NSArray *)contacts;

@end

@interface PeoplePickerViewController : UIViewController

@property(nonatomic) NSUInteger maxPickCount;
@property(nonatomic, weak) id<PeoplePickerViewControllerDelegate> delegate;

- (instancetype)initWithSelectedPhones:(NSArray *)selectedPhones;
- (void)setSelectedBlock:(void (^)(PeoplePickerViewController *peoplePickerViewController, NSArray *contacts))selectedBlock;

@end
