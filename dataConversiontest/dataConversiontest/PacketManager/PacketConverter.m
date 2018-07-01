//
//  PacketConverter.m
//  dataConversiontest
//
//  Created by Atul Anand on 29/06/18.
//  Copyright © 2018 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PacketConverter.h"


@implementation PacketConverter: NSObject

int sizeOfPacket = 20;

- (PacketStruct) convertDataToPacket:(NSData *)rcvdData
{
    PacketStruct blePacket;
    [rcvdData getBytes:&blePacket length:rcvdData.length];
    
    
    return blePacket;
}


-(void) createPacket:(PacketStruct *)packet from:(NSData *)data
{
    int len = data.length;
    [data getBytes:(packet->payloadData) length:len];
}

-(NSData *) getPacketAsData:(PacketStruct)packet
{
    NSData * data = [NSData dataWithBytes: &packet length:512];
    return data;
}

-(void)setSize:(int)size
{
    sizeOfPacket = size;
}

@end
