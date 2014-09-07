//
//  DLMainViewController.m
//  Delayed
//
//  Created by Win Raguini on 9/6/14.
//  Copyright (c) 2014 Win Inc. All rights reserved.
//

#import "DLMainViewController.h"
#import <Parse/Parse.h>
#import "DLNoteViewController.h"

@interface DLMainViewController ()
-(void)didSelectMinutesLateButton:(id)sender;
-(void)makeCall;
@property (nonatomic, assign) NSInteger minutesLate;
@end

@implementation DLMainViewController

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
    [self.tenButton addTarget:self action:@selector(didSelectMinutesLateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.fifteenButton addTarget:self action:@selector(didSelectMinutesLateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.twentyButton addTarget:self action:@selector(didSelectMinutesLateButton:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didSelectMinutesLateButton:(id)sender
{
//    [self makeCall];
   // [self startVenmo];
    UIButton *button = (UIButton*)sender;
    self.minutesLate = [button tag];
    NSLog(@"minutes %d", self.minutesLate);
    [self performSegueWithIdentifier:@"Note" sender:sender];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    DLNoteViewController *noteViewController = segue.destinationViewController;
    noteViewController.phoneNumber = @"4127369697";
    noteViewController.minutesLate = [NSNumber numberWithInteger:self.minutesLate];
}

- (void)makeCall
{
    NSString *phoneNumber = @"4127369697";
    // Call our Cloud Function that sends an SMS with Twilio
    [PFCloud callFunctionInBackground:@"inviteWithTwilio"
                       withParameters:@{ @"number" : phoneNumber, @"message" : @"Yo yo yo yo!" }
                                block:^(id object, NSError *error) {
                                    [[[UIAlertView alloc] initWithTitle:@"Invite Sent!"
                                                                message:@"Your SMS invitation has been sent!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil, nil] show];
                                }];
}

@end
