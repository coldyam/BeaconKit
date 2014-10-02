//
//  BeaconViewController.m
//  ESTBeacon
//
//  Created by Allen Tu on 2014-09-15.
//  Copyright (c) 2014 Cold Yam. All rights reserved.
//

#import "BeaconViewController.h"

#define BEACON_TABLEVIEWCELL_REUSEIDENTIFIER @"com.beaconviewcontroller.tableviewcell.reuseidentifier"

@interface BeaconViewController ()<BeaconKitDelegate>
@property (nonatomic, strong) NSArray *beacons;
@end

@implementation BeaconTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.imageView.image = [[UIImage imageNamed:@"beacon_linear"] tintColor:[UIColor whiteColor]];
        self.textLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.textColor = [UIColor whiteColor];
    }
    return self;
}
@end

@implementation BeaconViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"BEACON MONITOR", nil);
    [_tableView registerClass:[self tableViewCellClass]
       forCellReuseIdentifier:[self cellReuseIdentifier]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [(BeaconKit *)[BeaconKit sharedInstance] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[BeaconKit sharedInstance] setDelegate:nil];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView configuration
- (Class)tableViewCellClass
{
    return [BeaconTableViewCell class];
}

- (NSString *)cellReuseIdentifier
{
    return BEACON_TABLEVIEWCELL_REUSEIDENTIFIER;
}

#pragma mark - UITableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_beacons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeaconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier]
                                                            forIndexPath:indexPath];
    CLBeacon *beacon = [_beacons objectAtIndex:indexPath.row];
    cell.textLabel.text = [[BeaconKit sharedInstance] name:beacon];
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Distance: %@(%.2f)", nil), [[BeaconKit sharedInstance] proximity:beacon], beacon.accuracy];
    
    UIColor *beaconColor = [[BeaconKit sharedInstance] color:beacon];
    cell.contentView.backgroundColor = beaconColor;
    cell.textLabel.backgroundColor = beaconColor;
    cell.detailTextLabel.backgroundColor = beaconColor;
    
    UIColor *imageColor = ([[[BeaconKit sharedInstance] name:beacon] isEqualToString:[[BeaconKit sharedInstance] name]]) ? [UIColor redColor] : [UIColor whiteColor];
    cell.imageView.image = [[UIImage imageNamed:@"beacon_linear"] tintColor:imageColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CLBeacon *beacon = [_beacons objectAtIndex:indexPath.row];
    [[BeaconKit sharedInstance] startMonitoringForBeacon:beacon];
}

#pragma mark BeaconKit delegate
- (void)manager:(CLLocationManager *)manager
didRangeBeacons:(NSArray *)beacons
       inRegion:(CLBeaconRegion *)region
{
    _beacons = beacons;
    [_tableView reloadData];
}

@end
