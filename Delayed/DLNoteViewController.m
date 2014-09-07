//
//  DLNoteViewController.m
//  Delayed
//
//  Created by Win Raguini on 9/7/14.
//  Copyright (c) 2014 Win Inc. All rights reserved.
//

#import "DLNoteViewController.h"
#import <Parse/Parse.h>
#import <Venmo-iOS-SDK/Venmo.h>

@interface DLNoteViewController ()
- (void)didSelectGiftButton:(id)sender;
- (void)didSelectNoteButton:(id)sender;
- (void)sendSms;
-(void)startVenmo;
-(void)setDefaultVenmoTransactionMethod;
@end

@implementation DLNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.giftButton addTarget:self action:@selector(didSelectGiftButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.noteButton addTarget:self action:@selector(didSelectNoteButton:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectNoteButton:(id)sender
{
    [self sendSms];
}


- (void)didSelectGiftButton:(id)sender
{
    [self startVenmo];
}

- (NSString*)lateMessage
{
    if ([self.minutesLate intValue] < 20) {
        return [NSString stringWithFormat:@"Hey Christine, I'll be %@ minutes late.", self.minutesLate];
    } else {
        return [NSString stringWithFormat:@"Hey Christine, I'll be more than 20 minutes late."];
    }
}

- (void)sendSms
{
    NSString *message = [self lateMessage];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Sending note.";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something.
        // Call our Cloud Function that sends an SMS with Twilio
        [PFCloud callFunctionInBackground:@"inviteWithTwilio"
                           withParameters:@{ @"number" : self.phoneNumber, @"message" : message }
                                    block:^(id object, NSError *error) {
                                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                        hud.mode = MBProgressHUDModeText;
                                        hud.labelText = @"Note sent.";
                                        [hud hide:YES afterDelay:1.0f];
                                        [hud setDelegate:self];
                                    }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)startVenmo
{
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments,
                                                 VENPermissionAccessProfile]
                         withCompletionHandler:^(BOOL success, NSError *error) {
                             if (success) {
                                 // :)
                                 [self setDefaultVenmoTransactionMethod];
                             }
                             else {
                                 // :(
                                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                 hud.mode = MBProgressHUDModeText;
                                 hud.labelText = @"Error sending gift.";
                                 [hud hide:YES afterDelay:2.0f];
                             }
                         }];
}

- (void)setDefaultVenmoTransactionMethod
{
    if (![Venmo isVenmoAppInstalled]) {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
        [self sendPayment];
    }
    else {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
        [self sendPayment];
    }
}

- (void)sendPayment
{
    NSString *unencodedString = [NSString stringWithFormat:@" - %@ Grab a coffee on me!", [self lateMessage]];
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)unencodedString,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 ));

    [[Venmo sharedInstance] sendPaymentTo:@"4127369697"
                                   amount:300.0f
                                     note:unencodedString
                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                            if (success) {
//                                NSLog(@"Transaction succeeded!");
                                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                hud.mode = MBProgressHUDModeText;
                                hud.labelText = @"Coffee sent. Now hurry up!";
                                [hud hide:YES afterDelay:3.0f];
                                [hud setDelegate:self];
                            }
                            else {
                                NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
                            }
                        }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
