//
//  UsersListTableViewController.m
//  TestTask
//
//  Created by Roman on 5/25/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "UsersListTableViewController.h"
#import "UserListTableViewCell.h"
#import "DetailedUserInfoViewController.h"

@interface UsersListTableViewController ()
@property (nonatomic) NSArray *users;
//===
@property (nonatomic) IBOutlet UITableView *tableView;
@end

@implementation UsersListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _users = [[DataManager manager] getAllUsersInfo];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserListTableViewCell *cell = (UserListTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    UserInfo *userInfo = [self.users objectAtIndex:indexPath.row];
    cell.lblName.text = userInfo.name;
    cell.lblUserName.text = userInfo.userName;
    cell.lblPhoneNumber.text = userInfo.phoneNumber;
    return cell;
}

- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goToDetails" sender:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[DataManager manager] deleteInfo:indexPath.row];
    _users = [[DataManager manager] getAllUsersInfo];
    [self.tableView reloadData];
}

#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)sender
{
    if ([[segue identifier] isEqualToString:@"goToDetails"])
    {
        DetailedUserInfoViewController *detailedInfo = [DetailedUserInfoViewController new];
        detailedInfo = [segue destinationViewController];
        detailedInfo.indexCell = sender.row;
    }
}


@end
