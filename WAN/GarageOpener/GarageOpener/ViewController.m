//
//  ViewController.m
//  GarageOpener
//
//  Created by Joe Rocca on 7/30/16.
//  Copyright © 2016 Joe Rocca. All rights reserved.
//

#import "ViewController.h"
#import <PubNub/PubNub.h>

@interface ViewController ()<PNObjectEventListener>

@property (nonatomic) UIButton *openGarageButton;

@property (nonatomic) PubNub *client;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configureView];
    [self configureSubviews];
    [self configureConstraints];
    [self configurePubNub];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PNObjectEventListener

//Listeners callbacks:
- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    
    // Handle new message stored in message.data.message
    if (message.data.actualChannel) {
        
        // Message has been received on channel group stored in message.data.subscribedChannel.
    }
    else {
        
        // Message has been received on channel stored in message.data.subscribedChannel.
    }
    NSLog(@"Received message: %@ on channel %@ at %@", message.data.message,
          message.data.subscribedChannel, message.data.timetoken);
}

- (void)client:(PubNub *)client didReceiveStatus:(PNStatus *)status {
    
    if (status.operation == PNSubscribeOperation) {
        
        // Check whether received information about successful subscription or restore.
        if (status.category == PNConnectedCategory && status.category == PNReconnectedCategory) {
            
            // Status object for those categories can be casted to `PNSubscribeStatus` for use below.
            PNSubscribeStatus *subscribeStatus = (PNSubscribeStatus *)status;
            if (subscribeStatus.category == PNConnectedCategory) {
                
                // This is expected for a subscribe, this means there is no error or issue whatsoever.
            }
            else {
                
                /**
                 This usually occurs if subscribe temporarily fails but reconnects. This means there was
                 an error but there is no longer any issue.
                 */
            }
        }
        // Looks like some kind of issues happened while client tried to subscribe or disconnected from
        // network.
        else {
            
            PNErrorStatus *errorStatus = (PNErrorStatus *)status;
            if (errorStatus.category == PNAccessDeniedCategory) {
                
                /**
                 This means that PAM does allow this client to subscribe to this channel and channel group
                 configuration. This is another explicit error.
                 */
            }
            else if (errorStatus.category == PNUnexpectedDisconnectCategory) {
                
                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
            }
            else {
                
                /**
                 More errors can be directly specified by creating explicit cases for other error categories
                 of `PNStatusCategory` such as `PNTimeoutCategory` or `PNMalformedFilterExpressionCategory` or
                 `PNDecryptionErrorCategory`
                 */
            }
        }
    }
    else if (status.operation == PNUnsubscribeOperation) {
        
        if (status.category == PNDisconnectedCategory) {
            
            /**
             This is the expected category for an unsubscribe. This means there was no error in unsubscribing
             from everything.
             */
        }
    }
    else if (status.operation == PNHeartbeatOperation) {
        
        /**
         Heartbeat operations can in fact have errors, so it is important to check first for an error.
         For more information on how to configure heartbeat notifications through the status
         PNObjectEventListener callback, consult http://www.pubnub.com/docs/ios-objective-c/api-reference-sdk-v4#configuration_basic_usage
         */
        
        if (!status.isError) { /* Heartbeat operation was successful. */
        } else { /* There was an error with the heartbeat operation, handle here. */ }
    }
}

#pragma mark - IOT Functions

-(void)openGarage
{
    
    [self.client publish: @"Toggling Garage Door" toChannel: @"garage" storeInHistory:YES
          withCompletion:^(PNPublishStatus *status) {
              
              // Check whether request successfully completed or not.
              if (!status.isError) {
                  
                  // Message successfully published to specified channel.
              }
              // Request processing failed.
              else {
                  
                  /**
                   Handle message publish error. Check 'category' property to find
                   out possible reason because of which request did fail.
                   Review 'errorData' property (which has PNErrorData data type) of status
                   object to get additional information about issue.
                   
                   Request can be resent using: [status retry];
                   */
              }
          }];
}

#pragma mark - Configuration

-(void)configureView
{
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)configureSubviews
{
    self.openGarageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openGarageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.openGarageButton setTitle:@"Toggle Garage Door" forState:UIControlStateNormal];
    [self.openGarageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.openGarageButton setTitleColor:[UIColor colorWithWhite:0.0 alpha:0.5] forState:UIControlStateHighlighted];
    [self.openGarageButton addTarget:self action:@selector(openGarage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.openGarageButton];
}

-(void)configureConstraints
{
    [self.view addConstraint: [self.openGarageButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]];
    [self.view addConstraint: [self.openGarageButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]];
}

-(void)configurePubNub
{
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:@"pub-c-abd756e6-262b-4229-95f2-29a20c1dff51" subscribeKey:@"sub-c-15636f2c-5621-11e6-aba3-0619f8945a4f"];
    self.client = [PubNub clientWithConfiguration:configuration];
    
    [self.client addListener:self];
    
    [self.client subscribeToChannels: @[@"garage"] withPresence:NO];
}

@end
