//
//  PacketConverter.h
//  dataConversiontest
//
//  Created by Atul Anand on 29/06/18.
//  Copyright © 2018 com. All rights reserved.
//

#ifndef PacketConverter_h
#define PacketConverter_h


#endif /* PacketConverter_h */

#import<Foundation/Foundation.h>
extern int sizeOfPacket;
typedef struct PacketStruct{
    
    uint16_t        tp;
    uint16_t        len;
    uint8_t         cmd;
    uint8_t         payloadData[507];
}PacketStruct;

@interface PacketConverter : NSObject

- (PacketStruct) convertDataToPacket:(NSData *)rcvdData;
-(void) createPacket:(PacketStruct *)packet from:(NSData *)data;
-(NSData *) getPacketAsData:(PacketStruct)packet;
-(void)setSize:(int)size;


@end
