//
//  SketchAsyncHelper.h
//  SketchAsync
//
//  Created by James Tang on 27/3/2017.
//  Copyright © 2017 MagicSketch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mocha/Mocha.h>
@import JavaScriptCore;

@interface SketchAsyncHelper : NSObject

+ (JSValue *)callJavaScriptFunction:(MOJavaScriptObject*)object withArgumentsInArray:(NSArray *)args;
+ (void)callSketchActionID:(NSString *)actionID info:(NSDictionary *)info;

@end
