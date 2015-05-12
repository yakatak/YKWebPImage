//
//  UIImage+YKWebPImage.m
//  YKWebPImage
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

#import "UIImage+YKWebPImage.h"
#import <objc/runtime.h>
#import "YKSwizzle.h"
#import <decode.h>

static void releaseData(void *info, const void *data, size_t size) {
    if(info) {
        WebPDecoderConfig *config = (WebPDecoderConfig *)info;
        WebPDecBuffer *output = &(config->output);
        WebPFreeDecBuffer(output);
        free(info);
    }
    else {
        free((void *)data);
    }
}

@implementation UIImage (YKWebpImage)

#pragma mark Swizzling
+ (void)load {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        // -(instancetype)initWithData:(NSData *)data
        swizzleInstanceMethod(@"initWithData:", @"initWithData_yk:", self);
        
        // -(instancetype initWithData:(NSData *)data
        //                       scale:(CGFloat)scale
        swizzleInstanceMethod(@"initWithData:scale:", @"initWithData_yk:scale:", self);
        
        // -(instancetype initWithContentsOfFile:(NSString *)path
        swizzleInstanceMethod(@"initWithContentsOfFile:", @"initWithContentsOfFile_yk:", self);
        
        // +(instancetype imageNamed:(NSString *)name
        //                  inBundle:(NSBundle *)bundle
        // compatibleWithTraitCollection:(UITraitCollection *)traitCollection
        swizzleClassMethod(@"imageNamed:inBundle:compatibleWithTraitCollection:", @"yk_imageNamed:inBundle:compatibleWithTraitCollection:", self);
    });
}

#pragma mark Decoder
+ (UIImage *)webPImageFromData:(NSData *)data scale:(CGFloat)scale {
    // At the moment, traitCollections are ignored. We will add support for traitCollections... eventually :)
    
    // Nab the width and height from the data stream
    int width, height;
    if (!WebPGetInfo([data bytes], [data length], &width, &height)) {
        return nil;
    }
    
    // Create the decoder configuration
    WebPDecoderConfig *config = malloc(sizeof(WebPDecoderConfig));
    if (!WebPInitDecoderConfig(config)) {
        return nil;
    }
    
    config->options.bypass_filtering = 1;
    config->options.no_fancy_upsampling = 1;
    config->options.use_threads = 1;
    config->output.colorspace = MODE_RGBA;
    
    // Read the in-stream options
    if (WebPGetFeatures([data bytes], [data length], &(config->input)) != VP8_STATUS_OK) {
        return nil;
    }
    
    // Decode this sucker
    if (WebPDecode([data bytes], [data length], config) != VP8_STATUS_OK) {
        return nil;
    }
    
    // Convert to a UIImage via [UIImage imageWithCGImage:CGImageCreate()]
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaLast;
    CGDataProviderRef provider = CGDataProviderCreateWithData(config, config->output.u.RGBA.rgba, width * height * 4, releaseData);
    CGColorRenderingIntent intent = kCGRenderingIntentDefault;
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, 4 * width, colorSpace, bitmapInfo, provider, NULL, YES, intent);
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(cgImage);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    
    return image;
}

#pragma mark Init Methods
- (instancetype)initWithData_yk:(NSData *)data {
    UIImage *image = [UIImage webPImageFromData:data scale:1.0];
    if (image) {
        self = image;
        return image;
    }
    return [self initWithData_yk:data];
}

- (instancetype)initWithData_yk:(NSData *)data
                          scale:(CGFloat)scale {
    UIImage *image = [UIImage webPImageFromData:data scale:scale];
    if (image) {
        self = image;
        return self;
    }
    return [self initWithData_yk:data scale:scale];
}

- (instancetype)initWithContentsOfFile_yk:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    if (data) {
        UIImage *image = [UIImage webPImageFromData:data scale:1.0];
        if (image) {
            self = image;
            return image;
        }
    }
    return [self initWithContentsOfFile_yk:path];
}

+ (instancetype)yk_imageNamed:(NSString *)name
                     inBundle:(NSBundle *)bundle
compatibleWithTraitCollection:(UITraitCollection *)traitCollection {
    NSString *path = [bundle pathForResource:name ofType:nil];
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        if (data) {
            UIImage *image = [UIImage webPImageFromData:data scale:1.0];
            if (image) {
                return image;
            }
        }
    }
    return [self yk_imageNamed:name inBundle:bundle compatibleWithTraitCollection:traitCollection];
}


@end
