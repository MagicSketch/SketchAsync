//
//  SketchAsync.h
//  SketchAsync
//
//  Created by James Tang on 23/3/2017.
//  Copyright © 2017 MagicSketch. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for SketchAsync.
FOUNDATION_EXPORT double SketchAsyncVersionNumber;

//! Project version string for SketchAsync.
FOUNDATION_EXPORT const unsigned char SketchAsyncVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SketchAsync/PublicHeader.h>

#import <Mocha/Mocha.h>
@import JavaScriptCore;

/*
@protocol SketchAsync <JSExport>

JSExportAs(background,
- (void)runInBackground:(MOJavaScriptObject *)closure onCompletion:(MOJavaScriptObject *)completion
);

@end
*/

@interface SketchAsync : NSObject

- (void)runInBackground:(MOJavaScriptObject *)closure onCompletion:(MOJavaScriptObject *)completion;
- (void)runInBackground:(MOJavaScriptObject *)closure callbackActionID:(NSString *)callbackActionID;


+ (JSValue *)callJavaScriptFunction:(MOJavaScriptObject*)object withArgumentsInArray:(NSArray *)args;
+ (void)callSketchActionID:(NSString *)actionID info:(NSDictionary *)info;

@end
