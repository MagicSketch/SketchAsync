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

- (void)runInBackgroundForSeconds:(NSTimeInterval)seconds {
//    NSString *message = [NSString stringWithFormat:@"runInBackgroundForSeconds %f", seconds];
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


- (void)runInBackgroundForSeconds:(NSTimeInterval)seconds closure:(MOJavaScriptObject *)closure {

    JSValue *value = [SketchAsyncHelper callJavaScriptFunction:closure withArgumentsInArray:@[@2, @3]];

    NSString *stringResult = [value toString];

    NSLog(@"result %@", stringResult);
}

// Make sure to call coscript.setShouldKeepAround(true)
- (void)runInBackground:(MOJavaScriptObject *)closure onCompletion:(MOJavaScriptObject *)completion {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

      JSValue *value = [SketchAsyncHelper callJavaScriptFunction:closure
                                            withArgumentsInArray:nil];

      dispatch_async(dispatch_get_main_queue(), ^{
        // completion
        // http://gist.github.com/matt-curtis/4d

          [SketchAsyncHelper callJavaScriptFunction:completion
                               withArgumentsInArray:@[value]];

        });
    });
}

/*

+ (BOOL)isSelectorExcludedFromMochaScript:(SEL)selector {
        return NO;
}

+ (SEL)selectorForMochaPropertyName:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"background"]) {
        return @selector(runInBackground:onCompletion:);
    }
    return [super selectorForMochaPropertyName:propertyName];
}

 */

@end
