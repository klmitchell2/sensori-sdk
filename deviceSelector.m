/*
 *  deviceSelector.m
 *
 * Created by Ole Andreas Torvmark on 10/2/12.
 * Copyright (c) 2012 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 */

#import "deviceSelector.h"
#import "SensorObj.h"
#import "globalconf.h"

@interface deviceSelector ()

@end

@implementation deviceSelector
@synthesize m,nDevices,sensorTags;



- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.m = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        self.nDevices = [[NSMutableArray alloc]init];
        self.sensorTags = [[NSMutableArray alloc]init];
        self.title = @"Finding Hardware";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    self.m.delegate = self;
    
}

- (void)cancelBtnTapped:(UIButton*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return sensorTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld_Cell",(long)indexPath.row]];
    CBPeripheral *p = [self.sensorTags objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",p.name];
    cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:28.0f];
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",CFUUIDCreateString(nil, p.UUID)];  // deprecated in ios7
    NSString* sensor_alias;
    //    if ([[p.identifier UUIDString] isEqualToString:@"6F9B6DC3-5CA4-0CE8-CAAE-D711EC854EBC"])
    //        sensor_alias = @"Sensor 1";
    //    else
    //        sensor_alias = [p.identifier UUIDString];
    sensor_alias = [p.identifier UUIDString];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        if (self.sensorTags.count > 1 )return [NSString stringWithFormat:@"%d Sensori Hardware Found",self.sensorTags.count];
//        else return [NSString stringWithFormat:@"%d Sensori Hardware Found",self.sensorTags.count];
//    }
//
//    return @"";
//}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (headerView == nil) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 70.0f)];
        headerView.translatesAutoresizingMaskIntoConstraints = NO;
        headerView.backgroundColor = [UIColor colorWithRed:BLUE2_R green:BLUE2_G blue:BLUE2_B alpha:1.0f];
        UILabel *selectSensorLabel = [[UILabel alloc] initWithFrame:CGRectMake(69.0f, 23.0f, 0.0f, 0.0f)];
        selectSensorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        selectSensorLabel.text = @"Select a sensor";
        selectSensorLabel.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:28.0f];
        selectSensorLabel.textColor = [UIColor whiteColor];
        [selectSensorLabel sizeToFit];
        UIImage *cancelButtonImage = [UIImage imageNamed:@"cancel_button"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(287.0f, 33.0f, 20.0f, 20.0f)];
        [button setImage:cancelButtonImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        [headerView addSubview:selectSensorLabel];
    }
    return headerView;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //    if(footerView == nil) {
    //        //allocate the view if it doesn't exist yet
    //        footerView  = [[UIView alloc] init];
    //
    //        //create the button
    //        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //
    //        //the button should be as big as a table view cell
    //        [button setFrame:CGRectMake(10, 3, 150, 44)];
    //
    //        //set title, font size and font color
    //        [button setTitle:@"Cancel" forState:UIControlStateNormal];
    //        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    //
    //        //set action of the button
    //        [button addTarget:self action:@selector(cancelBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    //
    //        //add the button to the view
    //        [footerView addSubview:button];
    //    }
    //
    //    //return the view for the footer
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Table view delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBPeripheral *p = [self.sensorTags objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BLEDevice *d = [[BLEDevice alloc]init];
    
    d.p = p;
    d.manager = self.m;
    d.setupData = [self makeSensorTagConfiguration];
    
    [[SensorObj current] setSensor:d];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - CBCentralManager delegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"BLE not supported !" message:[NSString stringWithFormat:@"CoreBluetooth return state: %d",central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alertView show];
    }
    else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}




-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Found a BLE Device : %@",peripheral);
    
    /* iOS 6.0 bug workaround : connect to device before displaying UUID !
     The reason for this is that the CFUUID .UUID property of CBPeripheral
     here is null the first time an unkown (never connected before in any app)
     peripheral is connected. So therefore we connect to all peripherals we find.
     */
    
    peripheral.delegate = self;
    [central connectPeripheral:peripheral options:nil];
    
    [self.nDevices addObject:peripheral];
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral discoverServices:nil];
}

#pragma  mark - CBPeripheral delegate

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    BOOL replace = NO;
    BOOL found = NO;
    NSLog(@"Services scanned !");
    [self.m cancelPeripheralConnection:peripheral];
    for (CBService *s in peripheral.services) {
        NSLog(@"Service found : %@",s.UUID);
        
        if ([s.UUID isEqual:[CBUUID UUIDWithString:@"f000aa30-0451-4000-b000-000000000000"]])  {
            NSLog(@"This is a SensorTag !");
            found = YES;
        }
    }
    if (found) {
        // Match if we have this device from before
        //        for (int ii=0; ii < self.sensorTags.count; ii++) {
        //            CBPeripheral *p = [self.sensorTags objectAtIndex:ii];
        //            if ([p isEqual:peripheral]) {
        //                    [self.sensorTags replaceObjectAtIndex:ii withObject:peripheral];
        //                    replace = YES;
        //                }
        //            }
        if (!replace) {
            [self.sensorTags addObject:peripheral];
            [self.tableView reloadData];
        }
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@ error = %@",characteristic,error);
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic,error);
}


#pragma mark - SensorTag configuration

-(NSMutableDictionary *) makeSensorTagConfiguration {
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    
    // Easy setup
    [d setValue:@"f000aa30-0451-4000-b000-000000000000" forKey:@"Sensori Hardware service UUID"];
    [d setValue:@"f000aa31-0451-4000-b000-000000000000" forKey:@"Sensori Hardware data UUID"];
    [d setValue:@"f000aa32-0451-4000-b000-000000000000" forKey:@"Sensori Hardware control UUID"];
    
    [d setValue:@"f000aa40-0451-4000-b000-000000000000" forKey:@"Sensori Battery service UUID"];
    [d setValue:@"f000aa41-0451-4000-b000-000000000000" forKey:@"Sensori Battery level UUID"];
    
    NSLog(@"%@",d);
    
    return d;
}

@end
