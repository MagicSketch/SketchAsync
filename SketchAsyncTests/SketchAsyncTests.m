//
//  SketchAsyncTests.m
//  SketchAsyncTests
//
//  Created by James Tang on 23/3/2017.
//  Copyright © 2017 MagicSketch. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Mocha/Mocha.h>
#import <CocoaScript/COScript.h>
#import "SketchAsyncHelper.h"

@interface SketchAsyncTests : XCTestCase

@property (nonatomic, copy) NSString *script;
@property (nonatomic) id evalResult;
@property (nonatomic, strong) COScript *coscript;

@end


@implementation SketchAsyncTests

- (NSString *)contentsOfFile:(NSString *)fileName {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:nil];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    return content;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    self.script = [self contentsOfFile:@"SketchAsyncTests.js"];
    self.coscript = [[COScript alloc] init];
    self.evalResult = [self.coscript executeString:self.script];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testContentsOfFile {
    XCTAssertNotNil(self.script);
}

- (void)testMochaRuntime {
    XCTAssertNotNil([Mocha sharedRuntime]);
}

- (void)testEvalResult {
    NSLog(@"self.evalResult %@", self.evalResult);
    XCTAssertNotNil(self.evalResult);
}

- (void)testCOScript {
    XCTAssertNotNil(self.coscript);
}

- (void)testSum {
    id result = [self.coscript callFunctionNamed:@"sum" withArguments:@[@1, @2]];
    XCTAssertEqualObjects(result, @3);
}

- (void)testMain {

    XCTestExpectation *finishedMainExpectation = [self expectationWithDescription:@"finished main"];

    [self.coscript callFunctionNamed:@"main" withArguments:@[^{
        NSLog(@"calling finishedExpectation: %@", finishedMainExpectation);



        [finishedMainExpectation fulfill];
        NSLog(@"fulfilled");
    }]];

    [self waitForExpectationsWithTimeout:6 handler:^(NSError *error) {

    }];

}

/*
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
*/

@end
