//
//  PeoplePickerTableViewCell.m
//  Diange
//
//  Created by ZeroX on 14/12/24.
//  Copyright (c) 2014年 ZeroX. All rights reserved.
//

#import "PeoplePickerTableViewCell.h"
#import "UIColor+Hex.h"

@interface PeoplePickerTableViewCell ()

@property(nonatomic, weak) UIImageView *selectedMark;

@end

@implementation PeoplePickerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageView.image = [UIImage imageNamed:@"contact_unselected_mark"];
        self.imageView.highlightedImage = [UIImage imageNamed:@"contact_selected_mark"];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.textColor = [UIColor colorWithHex:0x333333];
        self.detailTextLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return self;
}

@end
