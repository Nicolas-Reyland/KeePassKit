//
//  KPKTestData.m
//  KeePassKit
//
//  Created by Michael Starke on 07.04.17.
//  Copyright © 2017 HicknHack Software GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KeePassKit.h"
#import "KeePassKit_Private.h"

@interface KPKTestData : XCTestCase

@end

@implementation KPKTestData

- (void)testDataStorage {
  NSData *randomData = [NSData kpk_dataWithRandomBytes:1111];
  KPKData *data = [[KPKData alloc] initWithProtectedData:randomData];
  XCTAssertEqualObjects(data.data, randomData);
  
  data = [[KPKData alloc] init];
  XCTAssertNil(data.data);
  data.data = randomData;
  XCTAssertEqualObjects(data.data, randomData);
}

- (void)testDataUpdate {
  KPKData *data =   data = [[KPKData alloc] init];
  data.protect = YES;
  XCTAssertNil(data.data);
  
  NSData *randomData = [NSData kpk_dataWithRandomBytes:1100];
  data.data = randomData;
  XCTAssertEqualObjects(data.data, randomData);

  NSData *randomData2 = [NSData kpk_dataWithRandomBytes:520];
  data.data = randomData2;
  XCTAssertEqualObjects(data.data, randomData2);
}

- (void)testDataProtection {
  NSData *randomData = [NSData kpk_dataWithRandomBytes:1080];
  KPKData *data = [[KPKData alloc] initWithProtectedData:randomData];
  
  XCTAssertEqual(data.length, randomData.length);
  XCTAssertNotEqualObjects(data.internalData, randomData);
  XCTAssertNotEqualObjects(data.xorPad, randomData);
}

- (void)testChangeDataProtection {
  NSData *randomData1 = [NSData kpk_dataWithRandomBytes:1024*512+50];
  NSData *randomData2 = [NSData kpk_dataWithRandomBytes:1024*1024+100];
  KPKData *data = [[KPKData alloc] initWithProtectedData:randomData1];
  XCTAssertEqual(data.protect, YES);
  XCTAssertNotNil(data.xorPad);
  XCTAssertNotEqualObjects(data.xorPad, randomData1);
  XCTAssertNotEqualObjects(data.internalData, randomData1);
  
  XCTAssertEqualObjects(data.data, randomData1);
  data.protect = NO;
  XCTAssertEqual(data.protect, NO);
  XCTAssertNil(data.xorPad);
  XCTAssertEqualObjects(data.internalData, randomData1);
  XCTAssertEqualObjects(data.data, randomData1);
  
  data.data = randomData2;
  XCTAssertNil(data.xorPad);
  XCTAssertEqual(data.protect, NO);
  XCTAssertEqualObjects(data.internalData, randomData2);
  XCTAssertEqualObjects(data.data, randomData2);
  
  data.protect = YES;
  XCTAssertEqual(data.protect, YES);
  XCTAssertNotNil(data.xorPad);
  XCTAssertNotEqualObjects(data.xorPad, randomData2);
  XCTAssertNotEqualObjects(data.internalData, randomData2);
  XCTAssertEqualObjects(data.data, randomData2);
}

- (void)testProtectedDataPerformance {
  KPKData *data = [[KPKData alloc] initWithProtectedData:[NSData kpk_dataWithRandomBytes:1024*1024+50]];
  [self measureBlock:^{
    for(NSUInteger count = 0; count < 100; count++) {
      XCTAssertNotNil(data.data);
    }
  }];
}

- (void)testUnprotectedDataPerformance {
  KPKData *data = [[KPKData alloc] initWithUnprotectedData:[NSData kpk_dataWithRandomBytes:1024*1024+25]];
  [self measureBlock:^{
    for(NSUInteger count = 0; count < 100; count++) {
      XCTAssertNotNil(data.data);
    }
  }];
}



@end
