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


@implementation SketchAsyncHelper

+ (JSValue *)callJavaScriptFunction:(MOJavaScriptObject*)object withArgumentsInArray:(NSArray *)args {

    JSContext *ctx = [JSContext contextWithJSGlobalContextRef:(JSGlobalContextRef)object.JSContext];
    JSObjectRef fn = [object JSObject];
    JSValue *value = [JSValue valueWithJSValueRef:fn inContext:ctx];
    JSValue *result = [value callWithArguments:args];

    return result;
}

@end
