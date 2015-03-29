//
//  PSWifiShareSettingVC.m
//  VLC for iOS
//
//  Created by DongYiming on 3/29/15.
//  Copyright (c) 2015 VideoLAN. All rights reserved.
//

#import "PSWifiShareSettingVC.h"
#import "VLCWiFiUploadTableViewCell.h"
#import "Reachability.h"
#import "VLCAppDelegate.h"
#import "VLCHTTPUploaderController.h"
#import "HTTPServer.h"

@interface PSWifiShareSettingVC () {
    UILabel *_uploadLocationLabel;
    UIButton *_uploadButton;
    Reachability *_reachability;
}
@property (nonatomic) VLCHTTPUploaderController *uploadController;
@property (nonatomic) VLCAppDelegate *appDelegate;

@end

@implementation PSWifiShareSettingVC

-(void)dealloc {
    [_reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = [VLCWiFiUploadTableViewCell heightOfCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.uploadController = self.appDelegate.uploadController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netReachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    _reachability = [Reachability reachabilityForLocalWiFi];
    [_reachability startNotifier];
    
    [self netReachabilityChanged:nil];
    
    BOOL isHTTPServerOn = [[NSUserDefaults standardUserDefaults] boolForKey:kVLCSettingSaveHTTPUploadServerStatus];
    [self.uploadController changeHTTPServerState:isHTTPServerOn];
    [self updateHTTPServerAddress];
}

- (void)netReachabilityChanged:(NSNotification *)notification
{
    if (_reachability.currentReachabilityStatus == ReachableViaWiFi) {
        _uploadButton.enabled = YES;
        [self updateHTTPServerAddress];
    } else {
        [_uploadButton setImage:[UIImage imageNamed:@"WifiUp"] forState:UIControlStateNormal];
        _uploadButton.enabled = NO;
        [_uploadButton setImage:[UIImage imageNamed:@"WiFiUp"] forState:UIControlStateDisabled];
        _uploadLocationLabel.text = NSLocalizedString(@"HTTP_UPLOAD_NO_CONNECTIVITY", nil);
        [self.uploadController changeHTTPServerState:NO];
    }
}


#pragma mark -

- (void)updateHTTPServerAddress
{
    HTTPServer *server = self.uploadController.httpServer;
    if (server.isRunning) {
        _uploadLocationLabel.numberOfLines = 0;
        
        if (server.listeningPort != 80) {
            _uploadLocationLabel.text = [NSString stringWithFormat:@"http://%@:%i\nhttp://%@:%i", [self.uploadController currentIPAddress], server.listeningPort, [self.uploadController hostname], server.listeningPort];
        } else {
            _uploadLocationLabel.text = [NSString stringWithFormat:@"http://%@\nhttp://%@", [self.uploadController currentIPAddress], [self.uploadController hostname]];
        }
        
        [_uploadButton setImage:[UIImage imageNamed:@"WifiUpOn"] forState:UIControlStateNormal];
    } else {
        _uploadLocationLabel.text = NSLocalizedString(@"HTTP_UPLOAD_SERVER_OFF", nil);
        [_uploadButton setImage:[UIImage imageNamed:@"WifiUp"] forState:UIControlStateNormal];
    }
}

- (IBAction)toggleHTTPServer:(UIButton *)sender
{
    if (_uploadButton.enabled) {
        BOOL futureHTTPServerState = !self.uploadController.httpServer.isRunning;
        
        [[NSUserDefaults standardUserDefaults] setBool:futureHTTPServerState forKey:kVLCSettingSaveHTTPUploadServerStatus];
        [self.uploadController changeHTTPServerState:futureHTTPServerState];
        [self updateHTTPServerAddress];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VLCWiFiUploadTableViewCell *cell = (VLCWiFiUploadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [VLCWiFiUploadTableViewCell cellWithReuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    _uploadLocationLabel = [(VLCWiFiUploadTableViewCell*)cell uploadAddressLabel];
    _uploadButton = [(VLCWiFiUploadTableViewCell*)cell serverOnButton];
    [_uploadButton addTarget:self action:@selector(toggleHTTPServer:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self toggleHTTPServer:nil];
}

@end
