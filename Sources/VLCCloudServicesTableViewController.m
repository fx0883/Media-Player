/*****************************************************************************
 * VLCCloudServicesTableViewController.m
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2014 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Carola Nitz <nitz.carola # googlemail.com>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

#import "UIBarButtonItem+Theme.h"
#import "VLCCloudServicesTableViewController.h"
#import "VLCAppDelegate.h"
#import "VLCDropboxTableViewController.h"
#import "VLCGoogleDriveTableViewController.h"
#import "VLCBoxTableViewController.h"
#import "VLCOneDriveTableViewController.h"
#import "VLCOneDriveController.h"
#import "VLCDocumentPickerController.h"
#import "VLCCloudServiceCell.h"

#import <DropboxSDK/DropboxSDK.h>
#import <BoxSDK/BoxSDK.h>
#import "VLCGoogleDriveController.h"

@interface VLCCloudServicesTableViewController ()

@property (nonatomic) VLCDropboxTableViewController *dropboxTableViewController;
@property (nonatomic) VLCGoogleDriveTableViewController *googleDriveTableViewController;
@property (nonatomic) VLCBoxTableViewController *boxTableViewController;
@property (nonatomic) VLCOneDriveTableViewController *oneDriveTableViewController;
@property (nonatomic) VLCDocumentPickerController *documentPickerController;

@end

@implementation VLCCloudServicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"CLOUD_SERVICES", "");

    [self.tableView registerNib:[UINib nibWithNibName:@"VLCCloudServiceCell" bundle:nil] forCellReuseIdentifier:@"CloudServiceCell"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem themedRevealMenuButtonWithTarget:self andSelector:@selector(goBack)];
    self.tableView.separatorColor = [UIColor VLCDarkBackgroundColor];

    self.dropboxTableViewController = [[VLCDropboxTableViewController alloc] initWithNibName:@"VLCCloudStorageTableViewController" bundle:nil];
    self.googleDriveTableViewController = [[VLCGoogleDriveTableViewController alloc] initWithNibName:@"VLCCloudStorageTableViewController" bundle:nil];
    self.boxTableViewController = [[VLCBoxTableViewController alloc] initWithNibName:@"VLCCloudStorageTableViewController" bundle:nil];
    self.oneDriveTableViewController = [[VLCOneDriveTableViewController alloc] initWithNibName:@"VLCCloudStorageTableViewController" bundle:nil];
    self.documentPickerController = [VLCDocumentPickerController new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationSessionsChanged:) name:VLCOneDriveControllerSessionUpdated object:nil];
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)goBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    VLCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [[appDelegate revealController] toggleSidebar:![appDelegate revealController].sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

- (void)authenticationSessionsChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UIDocumentPickerViewController class] ? 5 : 4;// on iOS 8+ add document picker option
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 0)? [UIColor blackColor]: [UIColor VLCDarkBackgroundColor];

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    VLCCloudServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CloudServiceCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: {
            //Dropbox
            BOOL isAuthorized = [[DBSession sharedSession] isLinked];
            cell.icon.image = [UIImage imageNamed:@"Dropbox"];
            cell.cloudTitle.text = @"Dropbox";
            cell.cloudInformation.text = isAuthorized ? NSLocalizedString(@"LOGGED_IN", "") : NSLocalizedString(@"LOGIN", "");
            break;
        }
        case 1: {
            //GoogleDrive
            BOOL isAuthorized = [[VLCGoogleDriveController sharedInstance] isAuthorized];
            cell.icon.image = [UIImage imageNamed:@"Drive"];
            cell.cloudTitle.text = @"Google Drive";
            cell.cloudInformation.text = isAuthorized ? NSLocalizedString(@"LOGGED_IN", "") : NSLocalizedString(@"LOGIN", "");
            break;
        }
        case 2: {
            //Box
            BOOL isAuthorized = [[BoxSDK sharedSDK].OAuth2Session isAuthorized];
            cell.icon.image = [UIImage imageNamed:@"Box"];
            cell.cloudTitle.text = @"Box";
            cell.cloudInformation.text = isAuthorized ? NSLocalizedString(@"LOGGED_IN", "") : NSLocalizedString(@"LOGIN", "");
            break;
        }
        case 3: {
            //OneDrive
            BOOL isAuthorized = [[VLCOneDriveController sharedInstance] isAuthorized];
            cell.icon.image = [UIImage imageNamed:@"OneDrive"];
            cell.cloudTitle.text = @"OneDrive";
            cell.cloudInformation.text = isAuthorized ? NSLocalizedString(@"LOGGED_IN", "") : NSLocalizedString(@"LOGIN", "");
            break;
        }
        case 4:
            //Cloud Drives
            cell.icon.image = [UIImage imageNamed:@"CloudDrives"];
            cell.cloudTitle.text = @"Cloud Drives";
            cell.cloudInformation.text = @"";
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // don't let select CLOUD_DRIVES menu item since there is no view controller to reveal
    if (indexPath.row == 4) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.documentPickerController showDocumentMenuViewController:[self.tableView cellForRowAtIndexPath:indexPath]];
        } else {
            [self.documentPickerController showDocumentMenuViewController:nil];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }

        return nil;
    } else
        return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:
            //dropBox
            [self.navigationController pushViewController:self.dropboxTableViewController animated:YES];
            break;
        case 1:
            //GoogleDrive
            [self.navigationController pushViewController:self.googleDriveTableViewController animated:YES];
            break;
        case 2:
            //Box
           [self.navigationController pushViewController:self.boxTableViewController animated:YES];
            break;
        case 3:
            //OneDrive
            [self.navigationController pushViewController:self.oneDriveTableViewController animated:YES];
            break;

        default:
            break;
    }
}

@end
