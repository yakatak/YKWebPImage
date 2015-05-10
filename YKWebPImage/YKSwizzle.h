//
//  YKSwizzle.h
//  YKWebPImage
//
//  Created by Peter Werry on 03/05/2015.
//
//

#import <Foundation/Foundation.h>

void swizzleInstanceMethod(NSString *original, NSString *replacement, Class clazz);

void swizzleClassMethod(NSString *original, NSString *replacement, Class clazz);
