//
//  DetailedUserInfoViewController.m
//  TestTask
//
//  Created by Roman on 5/26/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "DetailedUserInfoViewController.h"
#import "LocationViewController.h"
#import "EditUserInfoViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface DetailedUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
//===
@property (strong, nonatomic) SLComposeViewController *socialComposer;
@end

@implementation DetailedUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *users = [[DataManager manager] getAllUsersInfo];
    UserInfo *userInfo = [users objectAtIndex:self.indexCell];
    self.lblName.text = userInfo.name;
    self.lblUserName.text = userInfo.userName;
    self.lblPhoneNumber.text = userInfo.phoneNumber;
}

- (IBAction)btnShowLocationTapped:(id)sender
{
    [self performSegueWithIdentifier:@"goToLocation" sender:nil];
}

- (IBAction)btnFaceBookShareTapped:(id)sender
{
    NSString *facebookText = [NSString stringWithFormat:@"I am able to post any information!"];
    
    self.socialComposer = [[SLComposeViewController alloc] init];
    self.socialComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [self.socialComposer setInitialText:facebookText];
    [self presentViewController:self.socialComposer animated:YES completion:nil];
}

- (IBAction)btnTwitterShareTapped:(id)sender
{
    self.socialComposer = [[SLComposeViewController alloc] init];
    self.socialComposer =  [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [self.socialComposer setInitialText:@"Tweeting from my own app! :)"];
    [self presentViewController:self.socialComposer animated:YES completion:nil];
}

- (IBAction)btnEditTapped:(id)sender
{
    [self performSegueWithIdentifier:@"goToEdit" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToLocation"])
    {
        LocationViewController *location = [LocationViewController new];
        location = [segue destinationViewController];
        location.indexCell = self.indexCell;
    }
    else if ([[segue identifier] isEqualToString:@"goToEdit"])
    {
        EditUserInfoViewController *edit = [EditUserInfoViewController new];
        edit = [segue destinationViewController];
        edit.indexCell = self.indexCell;
    }
}

@end
