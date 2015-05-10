//
//  YKWebPImageTests.m
//  YKWebPImageTests
//
//  Created by Peter Werry on 28/04/2015.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface YKWebPImageTests : XCTestCase

@property (nonatomic, readonly) NSData *jpgData;
@property (nonatomic, readonly) NSData *webPData;

@end


@implementation YKWebPImageTests

- (NSData *)jpgData {
    NSError *error;
    NSString *filePath =  [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImages/1.sm.jpg" ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    
    XCTAssertNil(error, @"error: %@", error);
    XCTAssertNotNil(imageData);
    
    return imageData;
}

- (NSData *)webPData {
    NSError *error;
    NSString *filePath =  [[NSBundle bundleForClass:[self class]] pathForResource:@"TestImages/1.sm.webp" ofType:nil];
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
    UIImage *image = [UIImage imageWithData:self.webPData scale:0.0];
    XCTAssertNotNil(image, @"image was not created with WEBP");
}

- (void)testImageWithDataScaleJPG {
    UIImage *image = [UIImage imageWithData:self.jpgData scale:0.0];
    XCTAssertNotNil(image, @"image was not created with JPG");
}

#pragma mark [UIImage imageNamed:bundle:traitCollection]
- (void)testImageNamed {
    UIImage *image = [UIImage imageNamed:@"TestImages/1.sm.webp" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    XCTAssertNotNil(image, @"image was not created with WEBP");
}




@end
