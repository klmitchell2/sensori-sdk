//
//  SensorObj.m
//  Baseball Swing
//
//  Created by sqzhu on 2/3/14.
//  Copyright (c) 2014 sensori. All rights reserved.
//

#import "SensorObj.h"
#import "TISensors.h"
#import "BLEUtility.h"

@implementation SensorObj

-(id)init {
    self = [super init];
    if (self) {
        self.gyroSensor = [[sensorIMU3000 alloc] init];
        self.magSensor = [[sensorMAG3110 alloc] init];
        _sensor_connected = NO;
        _is_recording = NO;
    }
    return self;
}

+(SensorObj*)current {
    static SensorObj* inst = nil;
    @synchronized(self) {
        if (!inst)
            inst = [[self alloc] init];
    }
    return inst;
}

-(void)setSensor:(BLEDevice*)d {
    self.d = d;
    [self connectSensor];
}

-(BOOL) isConnected {
    if (!self.d)
        return NO;
    //    return self.d.p.isConnected; // deprecated in ios7
    return self.d.p.state == CBPeripheralStateConnected;
}

-(void) connectSensor {
    if (!self.d)
        return;
    //    if (!self.d.p.isConnected) {  // ios7 deprecated
    if (self.d.p.state != CBPeripheralStateConnected) {
        self.d.manager.delegate = self;
        [self.d.manager connectPeripheral:self.d.p options:nil];
    } else {
        self.d.p.delegate = self;
    }
}

-(void) disconnectSensor {
    if (!self.d)
        return;
    [self deconfigureSensorTag];
    //    self.sensorsEnabled = nil;
    [self.d.manager cancelPeripheralConnection:self.d.p];
    self.d.manager.delegate = nil;
}

-(void) startRecording {
    if (!self.d)
        return;
    _is_recording = YES;
    [self configureSensorTag];
}

-(void) stopRecording {
    _is_recording = NO;
    if (!self.d)
        return;
    [self deconfigureSensorTag];
}

// ******* MODIFIED FROM SENSORTAG **********

-(bool)sensorEnabled:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    if (val) {
        if ([val isEqualToString:@"1"]) return TRUE;
    }
    return FALSE;
}

-(int)sensorPeriod:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    return [val integerValue];
}

-(void) startReadingData {
    CBUUID* serviceUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Hardware service UUID"]];
    CBUUID* readingUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Hardware data UUID"]];
    uint8_t turn_on_dev = 1;
    [BLEUtility writeCharacteristic:self.d.p sCBUUID:serviceUUID cCBUUID:readingUUID data:[NSData dataWithBytes:&turn_on_dev length:1]];
    [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:serviceUUID cCBUUID:readingUUID enable:YES];
}

-(void) queryBattery {
    CBUUID* serviceUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Battery service UUID"]];
    CBUUID* controlUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Battery level UUID"]];
    uint8_t turn_on_dev = 1;
    [BLEUtility readCharacteristic:self.d.p sCBUUID:serviceUUID cCBUUID:controlUUID];
}

-(void) configureSensorTag {
    // Configure sensortag, turning on Sensors and setting update period for sensors etc ...
    // Turn on sensor
    CBUUID* serviceUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Hardware service UUID"]];
    CBUUID* controlUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Hardware control UUID"]];
    uint8_t turn_on_dev = 1;
    [BLEUtility writeCharacteristic:self.d.p sCBUUID:serviceUUID cCBUUID:controlUUID data:[NSData dataWithBytes:&turn_on_dev length:1]];
    
    // Sleep for a second and then start reading
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startReadingData) userInfo:nil repeats:NO];
    //    {
    //        CBUUID* serviceUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Hardware service UUID"]];
    //        CBUUID* readingUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Hardware data UUID"]];
    //        uint8_t turn_on_dev = 1;
    //        [BLEUtility writeCharacteristic:self.d.p sCBUUID:serviceUUID cCBUUID:readingUUID data:[NSData dataWithBytes:&turn_on_dev length:1]];
    //        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:serviceUUID cCBUUID:readingUUID enable:YES];
    //    }
    
    
}

-(void) deconfigureSensorTag {
    CBUUID* serviceUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Hardware service UUID"]];
    CBUUID* readingUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Hardware data UUID"]];
    CBUUID* controlUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Hardware control UUID"]];
    uint8_t turn_off_dev = 0;
    // Stop the reading process
    [BLEUtility writeCharacteristic:self.d.p sCBUUID:serviceUUID cCBUUID:readingUUID data:[NSData dataWithBytes:&turn_off_dev length:1]];
    // Turn off the control
    [BLEUtility writeCharacteristic:self.d.p sCBUUID:serviceUUID cCBUUID:controlUUID data:[NSData dataWithBytes:&turn_off_dev length:1]];
}


#pragma mark - CBCentralManager delegate function

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"****Central manager\n");
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    _sensor_connected = YES;
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    [self.delegate statusUpdatedWithConnection:YES];
}

-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    _sensor_connected = NO;
    [self.delegate statusUpdatedWithConnection:NO];
}

#pragma mark - CBperipheral delegate functions

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    // Commented out by sqzhu
    //    NSLog(@"..");
    //    if ([service.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope service UUID"]]]) {
    //        [self configureSensorTag];
    //    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@".");
    for (CBService *s in peripheral.services) [peripheral discoverCharacteristics:nil forService:s];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@, error = %@",characteristic.UUID, error);
}

-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}

-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}

// Sensor direction explanations:
/*
 SensorTag:
 label
 |
 v
 [==========**=====]
 ^
 |
 button
 
 LeadOff v1:
 
 [|=====***======]
 ^     ^      ^
 |     |      |
 button USB    LED
 
 
 ^ z
 |
 |
 acc, gyro & mag:  x *----> y
 
 
 
 screen:         ^ y
 |
 |
 z *-----> x
 
 
 To change quaternion from acce to screen, first rotate along ? axis by ?? degrees, then rotate along ?' axis by ?? degrees
 
 */

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    CBUUID* readingUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Hardware data UUID"]];
    CBUUID* controlUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Sensori Battery level UUID"]];
    if ([characteristic.UUID isEqual:controlUUID]) {
        unsigned char data;
        [characteristic.value getBytes:&data length:1];
        //        NSLog(@"Received good info: %d\n", data);
        [self.delegate receivedBatteryInfo:data];
    } else if ([characteristic.UUID isEqual:readingUUID]) {
        
        static float lasttime = -1;
        const float interval = 1.0/100;
        static int expect_packet = 0;
        static float mem_accxf, mem_accyf, mem_acczf;
        static bool mem_success;
        
        if (lasttime == -1)
            lasttime = 0; //[SensorData highPrecNow];
        
        // getting data out of array
        unsigned char data[20];
        [characteristic.value getBytes:data length:20];
        
        if ([peripheral.name isEqualToString:@"Sensori HWV2"]) {
            int16_t accx = (data[0] & 0xff) | ((data[1] << 8) & 0xff00);
            int16_t accy = (data[2] & 0xff) | ((data[3] << 8) & 0xff00);
            int16_t accz = (data[4] & 0xff) | ((data[5] << 8) & 0xff00);
            int16_t gyrox = (data[6] & 0xff) | ((data[7] << 8) & 0xff00);
            int16_t gyroy = (data[8] & 0xff) | ((data[9] << 8) & 0xff00);
            int16_t gyroz = (data[10] & 0xff) | ((data[11] << 8) & 0xff00);
            int16_t magx = (data[12] & 0xff) | ((data[13] << 8) & 0xff00);
            int16_t magy = (data[14] & 0xff) | ((data[15] << 8) & 0xff00);
            int16_t magz = (data[16] & 0xff) | ((data[17] << 8) & 0xff00);
            //    uint32_t time = data[15] | (((uint32_t)data[14]) << 8) | (((uint32_t)data[13]) << 16) | (((uint32_t)data[12]) << 24);
            int8_t item = data[18] & 0xff;
            int8_t overflow = data[19] & 0xff;
            //    NSLog(@"item = %d, overflow = %d", (int)item, (int)overflow);
            float accxf, accyf, acczf, gyroxf, gyroyf, gyrozf, magxf, magyf, magzf;
            accxf = ((float)accx) / (65536.0 / KXTJ9_RANGE);
            accyf = ((float)accy) / (65536.0 / KXTJ9_RANGE);
            acczf = ((float)accz) / (65536.0 / KXTJ9_RANGE);
            
            gyroxf = ((float)gyroy) / (65536.0 / IMU3000_RANGE) * (-1);
            gyroyf = ((float)gyrox) / (65536.0 / IMU3000_RANGE);
            gyrozf = ((float)gyroz) / (65536.0 / IMU3000_RANGE);
            
            magxf = ((float)magy) / (65536.0 / MAG3110_RANGE);
            magyf = ((float)magx) / (65536.0 / MAG3110_RANGE) * (-1);
            magzf = ((float)magz) / (65536.0 / MAG3110_RANGE);
            [self.delegate receivedDataTime:lasttime AccX:accxf Y:accyf Z:acczf GyroX:gyroxf Y:gyroyf Z:gyrozf MagX:magxf Y:magyf Z:magzf additional:nil];
            
        } else if ([peripheral.name hasPrefix:@"Sensori LeadOff 1"]) {
            const uint8_t INFO_BYTE = 18;
            const uint8_t MASK_PACKET_TYPE = 0x80;
            const uint8_t MASK_DATAPOINT1_SUCCESS = 0x40;
            const uint8_t MASK_DATAPOINT2_SUCCESS = 0x20;
            const uint8_t MASK_DATAPOINT3_SUCCESS = 0x10;
            const uint8_t MASK_OVERFLOW = 0x08;
            const int DATAPOINT1_INDEX = 0;
            const int DATAPOINT2_INDEX = 6;
            const int DATAPOINT3_INDEX = 12;
            
            const int ACC_RANGE = 32 * 3 / 2;  // -16G to +16G // dirty hack for acc offset
            const int GYRO_RANGE = 4000;  // -2000 to +2000
            
            if (!(data[INFO_BYTE] & MASK_PACKET_TYPE)) {
                // packet type 0
                int16_t accx = (data[DATAPOINT1_INDEX+0] & 0xff) | ((data[DATAPOINT1_INDEX+1] << 8) & 0xff00);
                int16_t accy = (data[DATAPOINT1_INDEX+2] & 0xff) | ((data[DATAPOINT1_INDEX+3] << 8) & 0xff00);
                int16_t accz = (data[DATAPOINT1_INDEX+4] & 0xff) | ((data[DATAPOINT1_INDEX+5] << 8) & 0xff00);
                int16_t gyrox = (data[DATAPOINT2_INDEX+1] & 0xff) | ((data[DATAPOINT2_INDEX+0] << 8) & 0xff00);
                int16_t gyroy = (data[DATAPOINT2_INDEX+3] & 0xff) | ((data[DATAPOINT2_INDEX+2] << 8) & 0xff00);
                int16_t gyroz = (data[DATAPOINT2_INDEX+5] & 0xff) | ((data[DATAPOINT2_INDEX+4] << 8) & 0xff00);
                
                float accxf = ((float)accx) / (65536.0 / ACC_RANGE);
                float accyf = ((float)accy) / (65536.0 / ACC_RANGE);
                float acczf = ((float)accz) / (65536.0 / ACC_RANGE);
                float gyroxf = ((float)gyroy) / (65536.0 / GYRO_RANGE) * (-1);
                float gyroyf = ((float)gyrox) / (65536.0 / GYRO_RANGE);
                float gyrozf = ((float)gyroz) / (65536.0 / GYRO_RANGE);
                
                NSString* additional = [NSString stringWithFormat:@"T:0 O:%d A:%d B:%d I:%d E:%d",
                                        (data[INFO_BYTE] & MASK_OVERFLOW ? 1 : 0),
                                        (data[INFO_BYTE] & MASK_DATAPOINT1_SUCCESS ? 1 : 0),
                                        (data[INFO_BYTE] & MASK_DATAPOINT2_SUCCESS ? 1 : 0),
                                        data[INFO_BYTE+1],
                                        expect_packet == 0 ? 1 : 0];
                
                [self.delegate receivedDataTime:lasttime AccX:accxf Y:accyf Z:acczf GyroX:gyroxf Y:gyroyf Z:gyrozf MagX:0 Y:0 Z:0 additional:additional];
                
                accx = (data[DATAPOINT3_INDEX+0] & 0xff) | ((data[DATAPOINT3_INDEX+1] << 8) & 0xff00);
                accy = (data[DATAPOINT3_INDEX+2] & 0xff) | ((data[DATAPOINT3_INDEX+3] << 8) & 0xff00);
                accz = (data[DATAPOINT3_INDEX+4] & 0xff) | ((data[DATAPOINT3_INDEX+5] << 8) & 0xff00);
                mem_accxf = ((float)accx) / (65536.0 / ACC_RANGE);
                mem_accyf = ((float)accy) / (65536.0 / ACC_RANGE);
                mem_acczf = ((float)accz) / (65536.0 / ACC_RANGE);
                mem_success = data[INFO_BYTE] & MASK_DATAPOINT3_SUCCESS;
                expect_packet = 1;
                
            } else {
                // packet type 1
                if (expect_packet == 1) {
                    // OK
                    int16_t gyrox = (data[DATAPOINT1_INDEX+1] & 0xff) | ((data[DATAPOINT1_INDEX+0] << 8) & 0xff00);
                    int16_t gyroy = (data[DATAPOINT1_INDEX+3] & 0xff) | ((data[DATAPOINT1_INDEX+2] << 8) & 0xff00);
                    int16_t gyroz = (data[DATAPOINT1_INDEX+5] & 0xff) | ((data[DATAPOINT1_INDEX+4] << 8) & 0xff00);
                    
                    float gyroxf = ((float)gyroy) / (65536.0 / GYRO_RANGE) * (-1);
                    float gyroyf = ((float)gyrox) / (65536.0 / GYRO_RANGE);
                    float gyrozf = ((float)gyroz) / (65536.0 / GYRO_RANGE);
                    
                    NSString* additional = [NSString stringWithFormat:@"T:1 :%d A:%d B:%d I:%d E:1",
                                            (data[INFO_BYTE] & MASK_OVERFLOW ? 1 : 0),
                                            (mem_success ? 1 : 0),
                                            (data[INFO_BYTE] & MASK_DATAPOINT1_SUCCESS ? 1 : 0),
                                            data[INFO_BYTE+1]];
                    
                    [self.delegate receivedDataTime:lasttime AccX:mem_accxf Y:mem_accyf Z:mem_acczf GyroX:gyroxf Y:gyroyf Z:gyrozf MagX:0 Y:0 Z:0 additional:additional];
                    lasttime += interval;
                }
                
                int16_t accx = (data[DATAPOINT2_INDEX+0] & 0xff) | ((data[DATAPOINT2_INDEX+1] << 8) & 0xff00);
                int16_t accy = (data[DATAPOINT2_INDEX+2] & 0xff) | ((data[DATAPOINT2_INDEX+3] << 8) & 0xff00);
                int16_t accz = (data[DATAPOINT2_INDEX+4] & 0xff) | ((data[DATAPOINT2_INDEX+5] << 8) & 0xff00);
                int16_t gyrox = (data[DATAPOINT3_INDEX+1] & 0xff) | ((data[DATAPOINT3_INDEX+0] << 8) & 0xff00);
                int16_t gyroy = (data[DATAPOINT3_INDEX+3] & 0xff) | ((data[DATAPOINT3_INDEX+2] << 8) & 0xff00);
                int16_t gyroz = (data[DATAPOINT3_INDEX+5] & 0xff) | ((data[DATAPOINT3_INDEX+4] << 8) & 0xff00);
                
                float accxf = ((float)accx) / (65536.0 / ACC_RANGE);
                float accyf = ((float)accy) / (65536.0 / ACC_RANGE);
                float acczf = ((float)accz) / (65536.0 / ACC_RANGE);
                float gyroxf = ((float)gyroy) / (65536.0 / GYRO_RANGE) * (-1);
                float gyroyf = ((float)gyrox) / (65536.0 / GYRO_RANGE);
                float gyrozf = ((float)gyroz) / (65536.0 / GYRO_RANGE);
                
                NSString* additional = [NSString stringWithFormat:@"T:2 O:%d A:%d B:%d I:%d E:%d",
                                        (data[INFO_BYTE] & MASK_OVERFLOW ? 1 : 0),
                                        (data[INFO_BYTE] & MASK_DATAPOINT2_SUCCESS ? 1 : 0),
                                        (data[INFO_BYTE] & MASK_DATAPOINT3_SUCCESS ? 1 : 0),
                                        data[INFO_BYTE+1],
                                        expect_packet == 1 ? 1 : 0];
                [self.delegate receivedDataTime:lasttime AccX:accxf Y:accyf Z:acczf GyroX:gyroxf Y:gyroyf Z:gyrozf MagX:0 Y:0 Z:0 additional:additional];
                expect_packet = 0;
            }
        } else {
            return;
        }
        //    float timef = ((float)time)*625/1000000;
        lasttime += interval;
    } else {
        NSLog(@"didUpdateUpdateValueForCharacteristic %@, error = %@",characteristic.UUID, error);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic.UUID,error);
}




@end
