//
//  EditUserInfoViewController.m
//  TestTask
//
//  Created by Roman on 5/26/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import "EditUserInfoViewController.h"

@interface EditUserInfoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *lblName;
@property (weak, nonatomic) IBOutlet UITextField *lblUserName;
@property (weak, nonatomic) IBOutlet UITextField *lblPhoneNumber;
//===
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation EditUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *users = [[DataManager manager] getAllUsersInfo];
    UserInfo *userInfo = [users objectAtIndex:self.indexCell];
    self.lblName.text = userInfo.name;
    self.lblUserName.text = userInfo.userName;
    self.lblPhoneNumber.text = userInfo.phoneNumber;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (IBAction)btnSaveTapped:(id)sender
{
    [[DataManager manager] changeInfoWithName:self.lblName.text userName:self.lblUserName.text phoneNumber:self.lblPhoneNumber.text andIndex:self.indexCell];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    self.activeField = sender;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender
{
    self.activeField = nil;
}

#pragma mark - TextFieldNatifications

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
@end
