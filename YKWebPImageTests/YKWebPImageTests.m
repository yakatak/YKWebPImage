//
//  YKWebPImageTests.m
//  YKWebPImageTests
//
//   Copyright Yakatak 2015
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface YKWebPImageTests : XCTestCase

@property (nonatomic, readonly) NSData *jpgData;
@property (nonatomic, readonly) NSString *jpgFilePath;
@property (nonatomic, readonly) NSData *webPData;
@property (nonatomic, readonly) NSString *webPFilePath;

@end


@implementation YKWebPImageTests

- (NSString *)jpgFilePath {
    return [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImages/1.sm.jpg" ofType:nil];
}

- (NSString *)webPFilePath {
    return [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImages/1.sm.webp" ofType:nil];
}

- (NSData *)jpgData {
    NSError *error;
    NSString *filePath = self.jpgFilePath;
    NSData *imageData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    
    XCTAssertNil(error, @"error: %@", error);
    XCTAssertNotNil(imageData);
    
    return imageData;
}

- (NSData *)webPData {
    NSError *error;
    NSString *filePath =  self.webPFilePath;
    NSData *imageData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    
    XCTAssertNil(error, @"error: %@", error);
    XCTAssertNotNil(imageData);
    
    return imageData;
}

#pragma mark [UIImage imageWithData:]
- (void)testImageWithDataWEBP {
    UIImage *image = [UIImage imageWithData:self.webPData];
    XCTAssertNotNil(image, @"image was not created for WEBP");
}

- (void)testImageWithDataJPG {
    UIImage *image = [UIImage imageWithData:self.jpgData];
    XCTAssertNotNil(image, @"image was not created with JPG");
}

#pragma mark [UIImage imageWithData:scale:]
- (void)testImageWithDataScaleWEBP {
    UIImage *image = [UIImage imageWithData:self.webPData scale:0.5];
    XCTAssertNotNil(image, @"image was not created with WEBP");
    XCTAssertEqual(image.scale, 0.5);
}

- (void)testImageWithDataScaleJPG {
    UIImage *image = [UIImage imageWithData:self.jpgData scale:0.5];
    XCTAssertNotNil(image, @"image was not created with JPG");
    XCTAssertEqual(image.scale, 0.5);
}

#pragma mark [UIImage imageWithContentsOfFile:]
- (void)testImageWithContentsOfFileWEBP {
    UIImage *image = [UIImage imageWithContentsOfFile:self.webPFilePath];
    XCTAssertNotNil(image, @"image was not created for WEBP");
}

- (void)testImageWithContentsOfFileJPG {
    UIImage *image = [UIImage imageWithContentsOfFile:self.jpgFilePath];
    XCTAssertNotNil(image, @"image was not created with JPG");
}

#pragma mark [UIImage imageNamed:bundle:traitCollection]
- (void)testImageNamed {
    UIImage *image = [UIImage imageNamed:@"TestImages/1.sm.webp" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    XCTAssertNotNil(image, @"image was not created with WEBP");
}

#pragma mark [UIImage initWithData:]
- (void)testInitWithDataWEBP {
    UIImage *image = [[UIImage alloc] initWithData:self.webPData];
    XCTAssertNotNil(image, @"image was not created for WEBP");
}

- (void)testInitWithDataJPG {
    UIImage *image = [[UIImage alloc] initWithData:self.jpgData];
    XCTAssertNotNil(image, @"image was not created with JPG");
}

#pragma mark [UIImage initWithData:scale:]
- (void)testInitWithDataScaleWEBP {
    UIImage *image = [[UIImage alloc] initWithData:self.webPData scale:0.5];
    XCTAssertNotNil(image, @"image was not created for WEBP");
    XCTAssertEqual(image.scale, 0.5);
}

- (void)testInitWithDataScaleJPG {
    UIImage *image = [[UIImage alloc] initWithData:self.jpgData scale:0.5];
    XCTAssertNotNil(image, @"image was not created with JPG");
    XCTAssertEqual(image.scale, 0.5);
}

#pragma mark [UIImage initWithContentsOfFile:]
- (void)testInitWithContentsOfFileWEBP {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:self.webPFilePath];
    XCTAssertNotNil(image, @"image was not created for WEBP");
}

- (void)testInitWithContentsOfFileJPG {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:self.jpgFilePath];
    XCTAssertNotNil(image, @"image was not created with JPG");
}


@end
