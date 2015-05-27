//
//  UserListTableViewCell.h
//  TestTask
//
//  Created by Roman on 5/25/15.
//  Copyright (c) 2015 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;

@end
