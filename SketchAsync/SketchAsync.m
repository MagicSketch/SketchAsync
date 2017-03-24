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
#import <Mocha/Mocha.h>
#import <Mocha/MOClosure.h>

#define SALog(fmt, ...) NSLog((@"SketchAsync (Sketch Plugin) %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

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

        [pluginManager performSelector:NSSelectorFromString(@"sendToInterestedCommandsActionWithID:context:") withObject:actionID withObject:context];

    });

}

- (void)runSomethingInBackgroundForSeconds:(NSTimeInterval)seconds closure:(MOJavaScriptObject *)closure {



    NSLog(@"closure: %@", closure);
    [(id)closure callFunctionWithName:@"run" withArguments:nil];
    NSLog(@"called");
}

@end
