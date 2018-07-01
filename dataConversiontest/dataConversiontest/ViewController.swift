//
//  ViewController.swift
//  dataConversiontest
//
//  Created by Atul Anand on 28/06/18.
//  Copyright © 2018 com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var startIndex = 0;
    
    var blePacketManager = PacketConverter()
    var buffer : NSMutableData?
    var header : NSMutableData?
    var c = 1
    var cc = 1
    var totalPayloadLen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizeOfPacket = 185
        self.testfunc()
        self.check()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testfunc()
    {
        var data = "123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789123456789".data(using: String.Encoding.utf8)
        
        self.createChunks(forData: data!)
    }
    
    func receiveData(data : Data)
    {
        
        let packetReceived = self.blePacketManager.convertData(toPacket: data)
        self.totalPayloadLen += Int(packetReceived.len)
        if(c == 1)
        {
            
            if(packetReceived.tp > 1)
            {
                c = Int(packetReceived.tp)
                buffer = NSMutableData()
                data.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
                    let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
                    let offset = 0
                    let len = data.count - offset
                    let payload = Data(bytesNoCopy: mutRawPointer+offset, count: len, deallocator: Data.Deallocator.none)
                    buffer?.append(payload)
                    
                }
                cc += 1
            }
            else
            {
                
            }
        }
        else
        {
            data.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
                let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
                let offset = 5
                let len = data.count - offset
                var payload = Data(bytesNoCopy: mutRawPointer + offset, count: len, deallocator: Data.Deallocator.none)
                buffer?.append(payload)
                
            }
            
            if(cc == c)
            {
                c = 1
                cc = 1
                let dataaa = Data(buffer as! Data)
                var packetReceived2 = self.blePacketManager.convertData(toPacket: dataaa)
                packetReceived2.len = UInt16(self.totalPayloadLen)
                let strData = Data(bytesNoCopy: UnsafeMutableRawPointer(&packetReceived2)+5, count: self.totalPayloadLen, deallocator: Data.Deallocator.none)
                
                print("-----------\(String(data: strData, encoding: String.Encoding.utf8))")
                print("wohoo ")
            }
        }
    }
    
    func createChunks(forData: Data)
    {
     
        forData.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
            let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
            let uploadChunkSize = Int(sizeOfPacket) - 5
            let totalSize = forData.count
            var offset = 0
            print("-------\(mutRawPointer)")
            while offset < totalSize {
                
                let chunkSize = offset + uploadChunkSize > totalSize ? totalSize - offset : uploadChunkSize
                let chunk = Data(bytesNoCopy: mutRawPointer+offset, count: chunkSize, deallocator: Data.Deallocator.none)
                var blePacket = PacketStruct()
                blePacket.cmd = 6
                blePacket.tp = 2
                blePacket.len = UInt16(chunk.count)
                self.blePacketManager.createPacket(&blePacket, from: chunk)
                let dataToSend = Data(bytes: &blePacket, count: 5 + chunk.count)
                
                offset += chunkSize
                self.receiveData(data: dataToSend)
            }
        }
    }
    
    func check()
    {
        
    }
    
    func setSize(size : Int)
    {
        self.blePacketManager.setSize(185)
    }

}

