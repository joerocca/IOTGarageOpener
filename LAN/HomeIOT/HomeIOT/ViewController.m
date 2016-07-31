//
//  ViewController.m
//  HomeIOT
//
//  Created by Joe Rocca on 2/13/16.
//  Copyright © 2016 Joe Rocca. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"

@interface ViewController ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic) UIButton *openGarageButton;
@property (nonatomic) GCDAsyncUdpSocket *udpSocket;

@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self connectToHost];
    [self configureSubviews];
    [self configureConstraints];

}

#pragma mark - Host Connect

-(void)connectToHost
{
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error;
    
    [self.udpSocket connectToHost:@"192.168.25.28" onPort:10000 error:&error];
    [self.udpSocket beginReceiving:&error];
    
    if (error != nil)
    {
        NSLog(@"%@", error.localizedDescription);
    }
}

#pragma mark - GCDAsyncUdpSocketDelegate

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSLog(@"Did connect");
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    NSLog(@"Did not connect");
}

-(void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"Error");
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"MSG: %@",msg);
}

#pragma mark - IOT Functions

-(void)openGarage
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"signal": @"1"}
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil)
    {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    [self.udpSocket sendData:jsonData withTimeout:-1 tag:1];
}

#pragma mark - Configuration

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

@end