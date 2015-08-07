//
//  APContact.h
//  APAddressBook
//
//  Created by Alexey Belkevich on 1/10/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "APTypes.h"

@interface APContact : NSObject

@property (nonatomic) APContactField fieldMask;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *middleName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *compositeName;
@property (nonatomic) NSString *company;
@property (nonatomic) NSString *jobTitle;
@property (nonatomic) NSArray *phones;
@property (nonatomic) NSArray *phonesWithLabels;
@property (nonatomic) NSArray *emails;
@property (nonatomic) NSArray *addresses;
@property (nonatomic) UIImage *photo;
@property (nonatomic) UIImage *thumbnail;
@property (nonatomic) NSNumber *recordID;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSDate *modificationDate;
@property (nonatomic) NSArray *socialProfiles;
@property (nonatomic) NSString *note;
@property (nonatomic) NSArray *linkedRecordIDs;

- (id)initWithRecordRef:(ABRecordRef)recordRef fieldMask:(APContactField)fieldMask;

@end
