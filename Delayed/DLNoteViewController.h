//
//  DLNoteViewController.h
//  Delayed
//
//  Created by Win Raguini on 9/7/14.
//  Copyright (c) 2014 Win Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface DLNoteViewController : UIViewController <MBProgressHUDDelegate>
@property (nonatomic, strong) IBOutlet UIButton *giftButton;
@property (nonatomic, strong) IBOutlet UIButton *noteButton;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, strong) NSNumber *minutesLate;
@end
