//
//  SketchAsyncHelper.m
//  SketchAsync
//
//  Created by James Tang on 27/3/2017.
//  Copyright © 2017 MagicSketch. All rights reserved.
//

#import "SketchAsyncHelper.h"

#import <Mocha/MOClosure.h>
#import <Mocha/MOJavaScriptObject.h>
#import <Mocha/MochaRuntime_Private.h>
#import <CocoaScript/COScript.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation SketchAsyncHelper

+ (JSValue *)callJavaScriptFunction:(MOJavaScriptObject *)object withArgumentsInArray:(NSArray *)args {

    JSContext *ctx = [JSContext contextWithJSGlobalContextRef:(JSGlobalContextRef)object.JSContext];
    JSObjectRef fn = [object JSObject];
    JSValue *value = [JSValue valueWithJSValueRef:fn inContext:ctx];
    JSValue *result = [value callWithArguments:args];

    return result;
}

+ (void)callSketchActionID:(NSString *)actionID info:(NSDictionary *)info {

    NSObject *appController = [[NSApplication sharedApplication] valueForKey:@"delegate"];
    NSObject *pluginManager = [appController valueForKeyPath:@"pluginManager"];
    NSDictionary *pluginContext = [appController valueForKeyPath:@"pluginContext"];


    NSMutableDictionary *context = [NSMutableDictionary dictionaryWithDictionary:pluginContext];

    NSLog(@"pluginManager: %@", pluginManager);
    NSLog(@"context: %@", context);

    [context addEntriesFromDictionary:info];

    SuppressPerformSelectorLeakWarning(
    [pluginManager performSelector:NSSelectorFromString(@"sendToInterestedCommandsActionWithID:context:") withObject:actionID withObject:context];
                                     );

}

@end
