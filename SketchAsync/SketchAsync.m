//
//  SketchAsync.m
//  SketchAsync
//
//  Created by James Tang on 23/3/2017.
//  Copyright © 2017 MagicSketch. All rights reserved.
//

#import "SketchAsync.h"
@import AppKit;
@import JavaScriptCore;
#import "SketchAsyncHelper.h"
#import <Mocha/MOJavaScriptObject.h>

#define SALog(fmt, ...) NSLog((@"SketchAsync (Sketch Plugin) %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define SuppressPerformSelectorLeakWarning(Stuff) \
// http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation SketchAsync

- (NSString *)runSomething {
    SALog(@"runSomething");
    return @"runSomething";
}

- (void)runSomethingInBackgroundForSeconds:(NSTimeInterval)seconds {
//    NSString *message = [NSString stringWithFormat:@"runSomethingInBackgroundForSeconds %f", seconds];
//    SALog(@"%@", message);
//    return message;

    /*
    function sendAction(actionID, info) {
        var pluginManager = [AppController sharedInstance].pluginManager();
        // var commands = pluginManager.commandsWithActionHandlers();

        var c = pluginManager.contextForActionWithID_context_(actionID, context).mutableCopy()
        c["info"] = info;
        pluginManager.sendToInterestedCommandsActionWithID_context_(actionID, c)
    }
    
    sendAction("-Edit.finish", {"custom":1})
     */

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        NSString *actionID = @"SketchAsync.finish";
        NSObject *appController = [NSClassFromString(@"AppController") valueForKeyPath:@"sharedInstance"];
        NSObject *pluginManager = [appController valueForKeyPath:@"pluginManager"];
        NSDictionary *pluginContext = [appController valueForKeyPath:@"pluginContext"];

//        NSMutableDictionary *context = [[pluginManager performSelector:NSSelectorFromString(@"contextForActionWithID:context:") withObject:actionID withObject:pluginContext] mutableCopy];

        NSMutableDictionary *context = [NSMutableDictionary dictionaryWithDictionary:pluginContext];

        context[@"SketchAsyncDuration"] = @(seconds);
        NSLog(@"pluginManager: %@", pluginManager);
        NSLog(@"context: %@", context);

        SuppressPerformSelectorLeakWarning(
            [pluginManager performSelector:NSSelectorFromString(@"sendToInterestedCommandsActionWithID:context:") withObject:actionID withObject:context];
                                           );

    });

}


- (void)runSomethingInBackgroundForSeconds:(NSTimeInterval)seconds closure:(MOJavaScriptObject *)closure {

    JSValue *value = [SketchAsyncHelper callJavaScriptFunction:closure withArgumentsInArray:@[@2, @3]];

    NSString *stringResult = [value toString];

    NSLog(@"result %@", stringResult);
}


- (void)runSomethingInBackground:(MOJavaScriptObject *)closure onCompletion:(MOJavaScriptObject *)completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
/*
    NSArray *args = @[@1, @3];
    JSContext *ctx = [JSContext contextWithJSGlobalContextRef:(JSGlobalContextRef)closure.JSContext];
    JSObjectRef fn = [closure JSObject];
    JSValue *value = [JSValue valueWithJSValueRef:fn inContext:ctx];
*/
      JSValue *value = [SketchAsyncHelper callJavaScriptFunction:closure
                                            withArgumentsInArray:@[@1, @3]];

      dispatch_async(dispatch_get_main_queue(), ^{
        // completion
        // http://gist.github.com/matt-curtis/4d


          /*JSValue *result = [value callWithArguments:args];
        NSString *stringResult = [result toString];

          NSLog(@"stringResult: %@", stringResult);
*/

          [SketchAsyncHelper callJavaScriptFunction:completion
                               withArgumentsInArray:@[[value toString]]];
        });
    });
}

@end
