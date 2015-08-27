//
//  AuchViewController.m
//  vk-wall
//
//  Created by Anton Minin on 26/08/15.
//  Copyright (c) 2015 Anton Minin. All rights reserved.
//

#import "AuchViewController.h"

#import "AccessToken.h"

NSString *const kAuchUrl = @"https://oauth.vk.com/authorize";
NSString *const kClientId = @"5046733";
NSString *const kRedirectUri = @"https://oauth.vk.com/blank.html";
NSString *const kDisplay = @"mobile";
NSString *const kScope = @"wall"; //wall(+8192)
NSString *const kResponceType = @"token";
NSString *const kVersion = @"5.37";

@interface AuchViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation AuchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* urlString = [NSString stringWithFormat:@"%@?client_id=%@&display=%@&redirect_uri=%@&scope=%@&response_type=%@&v=%@&revoke=1", kAuchUrl, kClientId, kDisplay, kRedirectUri, kScope, kResponceType, kVersion];
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"URL %@", request.URL);
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"URL %@", webView.request.URL);
    AccessToken *token = [[AccessToken alloc] initWithURL:webView.request.URL];
    if ([token isLoggedIn]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
