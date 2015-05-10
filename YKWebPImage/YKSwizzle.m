//
//  YKSwizzle.m
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
