//
//  YKSwizzle.m
//  YKWebPImage
//
//  Created by Peter Werry on 03/05/2015.
//
//

#import "YKSwizzle.h"
#import <objc/runtime.h>

/**
 * Uses this swizzle method by Mattt Thompson: http://nshipster.com/method-swizzling/
 */
void swizzleThisShizzle(Method originalMethod, Method replacementMethod, Class clazz) {
    SEL originalSelector = method_getName(originalMethod);
    SEL replacementSelector = method_getName(replacementMethod);
    
    IMP originalImplementation = method_getImplementation(originalMethod);
    IMP replacementImplementation = method_getImplementation(replacementMethod);
    
    const char *originalTypes = method_getTypeEncoding(originalMethod);
    const char *replacementTypes = method_getTypeEncoding(replacementMethod);
    
    BOOL didAddMethod = class_addMethod(clazz, originalSelector, replacementImplementation, replacementTypes);
    
    if (didAddMethod) {
        class_replaceMethod(clazz, replacementSelector, originalImplementation, originalTypes);
    } else {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
}

void swizzleInstanceMethod(NSString *original, NSString *replacement, Class classObject) {
    Class clazz = [classObject class];
    
    Method originalMethod = class_getInstanceMethod(clazz, NSSelectorFromString(original));
    Method replacementMethod = class_getInstanceMethod(clazz, NSSelectorFromString(replacement));
    
    swizzleThisShizzle(originalMethod, replacementMethod, clazz);
}

void swizzleClassMethod(NSString *original, NSString *replacement, Class classObject) {
    Class clazz = object_getClass(classObject);
    
    Method originalMethod = class_getClassMethod(clazz, NSSelectorFromString(original));
    Method replacementMethod = class_getClassMethod(clazz, NSSelectorFromString(replacement));
    
    swizzleThisShizzle(originalMethod, replacementMethod, clazz);
}
