//
//  PeoplePickerViewController.m
//  Diange
//
//  Created by ZeroX on 14/12/19.
//  Copyright (c) 2014年 ZeroX. All rights reserved.
//

#import "PeoplePickerViewController.h"
#import "PeoplePickerTableViewCell.h"
#import "ContactsSearchBar.h"
#import "APAddressBook+Conveniences.h"
#import "APContact+Conveniences.h"
#import "UIView+Toast.h"
#import "UIView+Size.h"
#import "UIColor+Hex.h"
#import "RMUniversalAlert.h"

typedef void (^PeoplePickerViewControllerSelectedBlock)(PeoplePickerViewController *, NSArray *);

static NSString *contactsTableViewCellIdentifier = @"contactsTableViewCellIdentifier";

@interface PeoplePickerViewController () <UITableViewDataSource, UITableViewDelegate, SearchBarDelegate, ContactsPickerViewDataSource, ContactsPickerViewDelegate>

@property(nonatomic, strong) NSArray *filteredContactSections;
@property(nonatomic, strong) NSMutableArray *selectedContacts;
@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, weak) ContactsSearchBar *searchBar;
@property(nonatomic, copy) PeoplePickerViewControllerSelectedBlock selectedBlock;

@end

@implementation PeoplePickerViewController

- (void)setSelectedBlock:(void (^)(PeoplePickerViewController *, NSArray *))selectedBlock
{
    _selectedBlock = selectedBlock;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    return [self initWithSelectedPhones:nil];
}

- (instancetype)initWithSelectedPhones:(NSArray *)selectedPhones
{
    if (self = [super init])
    {
        _selectedContacts = selectedPhones ? [selectedPhones mutableCopy] : [NSMutableArray array];
        _maxPickCount = NSUIntegerMax;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"联系人";
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                          style:UIBarButtonItemStyleDone
                                                                         target:self
                                                                         action:@selector(doneBarButtonItemTapped:)];
    doneBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
    [self setupSearchBar];
    [self setupTableView];
    [self getAllContacts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getAllContacts)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[UITableView appearance] setSectionIndexBackgroundColor:[UIColor clearColor]];
    [[UITableView appearance] setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
    
    if ([APAddressBook access] == APAddressBookAccessDenied)
    {
        [RMUniversalAlert showAlertInViewController:self withTitle:@"" message:@"请在系统设置中打开“真心点歌”的通讯录使用权限来读取联系人信息" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:NULL];
    }
}

- (void)doneBarButtonItemTapped:(UIBarButtonItem *)sender
{
    if ([_delegate respondsToSelector:@selector(peoplePickerViewController:didSelectContacts:)])
    {
        [_delegate peoplePickerViewController:self didSelectContacts:[NSArray arrayWithArray:_selectedContacts]];
    }
    if (_selectedBlock)
    {
        _selectedBlock(self, [NSArray arrayWithArray:_selectedContacts]);
    }
}

- (void)setupSearchBar
{
    ContactsSearchBar *searchBar = [[ContactsSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    searchBar.delegate = self;
    searchBar.contactsPickerView.dataSource = self;
    searchBar.contactsPickerView.delegate = self;
    [self.view addSubview:searchBar];
    _searchBar = searchBar;
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, self.view.width, self.view.height - _searchBar.bottom)];
    [tableView registerClass:[PeoplePickerTableViewCell class]
      forCellReuseIdentifier:contactsTableViewCellIdentifier];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.rowHeight = 55;
    tableView.allowsMultipleSelection = YES;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)getAllContacts
{
    [APAddressBook getAllContactsWithCompletion:^(NSArray *contactSections) {
        _filteredContactSections = [contactSections copy];
        for (APContact *contact in _selectedContacts)
        {
            contact.firstName = [APAddressBook contactNameFromPhone:contact.phones.firstObject];
            contact.lastName = nil;
        }
        [_tableView reloadData];
        [_searchBar reloadData];
        self.navigationItem.rightBarButtonItem.enabled = (_selectedContacts.count > 0);
    }];
}

- (void)filterContactsWithKeyword:(NSString *)keyword
{
    [APAddressBook filterContactsWithKeyword:keyword filterMask:APContactFilterAll completion:^(NSArray *filteredContactSections) {
        if ([keyword isEqualToString:_searchBar.text])
        {
            _filteredContactSections = [filteredContactSections copy];
            [_tableView reloadData];
        }
    }];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _filteredContactSections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *contacts = _filteredContactSections[section];
    return contacts.count > 0 ? 20 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHex:0xebebeb];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor colorWithHex:0x4c4c4c];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    headerLabel.text = [[UILocalizedIndexedCollation currentCollation] sectionTitles][section];
    [view addSubview:headerLabel];
    return view;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *contacts = _filteredContactSections[section];
    return contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeoplePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contactsTableViewCellIdentifier
                                                                        forIndexPath:indexPath];
    
    APContact *contact = _filteredContactSections[indexPath.section][indexPath.row];
    NSString *title = contact.fullName;
    NSString *subTitle = contact.phones.firstObject;
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subTitle;
    cell.imageView.highlighted = [_selectedContacts containsObject:contact];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    APContact *contact = _filteredContactSections[indexPath.section][indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_selectedContacts.count >= _maxPickCount && !cell.imageView.highlighted)
    {
        [self.view makeToast:[NSString stringWithFormat:@"最多选择%ld人", (long)_maxPickCount] duration:2.0 position:@0.5];
        return;
    }
    
    tableView.userInteractionEnabled = NO;
    if (!cell.imageView.highlighted)
    {
        [_selectedContacts addObject:contact];
        [_searchBar insertContactAtIndex:(_selectedContacts.count-1) animated:YES completion:^(BOOL finished) {
            tableView.userInteractionEnabled = YES;
        }];
    }
    else
    {
        NSUInteger index = [_selectedContacts indexOfObject:contact];
        if (index != NSNotFound)
        {
            [_selectedContacts removeObjectAtIndex:index];
            [_searchBar deleteContactAtIndex:index animated:YES completion:^(BOOL finished) {
                tableView.userInteractionEnabled = YES;
            }];
        }
    }
    
    [tableView reloadData];
    self.navigationItem.rightBarButtonItem.enabled = (_selectedContacts.count > 0);
}

#pragma mark - SearchBarDelegate

- (void)searchBar:(SearchBar *)searchBar textDidChange:(NSString *)text;
{
    [self filterContactsWithKeyword:text];
}

- (void)searchBarSearchButtonClicked:(SearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - ContactsPickerViewDataSource

- (NSInteger)numberOfContactsInContactsPickerView:(ContactsPickerView *)contactsPickerView
{
    return _selectedContacts.count;
}

- (NSString *)contactsPickerView:(ContactsPickerView *)contactsPickerView contactNameAtIndex:(NSUInteger)index
{
    APContact *contact = _selectedContacts[index];
    return contact.fullName;
}

#pragma mark - ContactsPickerViewDelegate

- (void)contactsPickerView:(ContactsPickerView *)contactsPickerView didDeleteContactAtIndex:(NSUInteger)index
{
    [_selectedContacts removeObjectAtIndex:index];
    [_tableView reloadData];
    self.navigationItem.rightBarButtonItem.enabled = (_selectedContacts.count > 0);
    _tableView.userInteractionEnabled = NO;
    [_searchBar deleteContactAtIndex:index animated:YES completion:^(BOOL finished) {
        _tableView.userInteractionEnabled = YES;
    }];
}

@end
