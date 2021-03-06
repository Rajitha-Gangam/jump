/*
 * Copyright (c) 2011 - SEQOY.org and Paulo Oliveira ( http://www.seqoy.org ) 
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import <GHUnitIOS/GHUnit.h> 
#import "JPLogNSLogLogger.h"
#import "JPNSLogFactory.h"
#import "JPLoggerShortcuts.h"
#import "JUMPLoggerConfig.h"

//////////// //////////// //////////// /////
/**
 * JUMP Database Module Unit Tests
 */
@interface JUMPNSLogTest : GHTestCase {}
@end  

//////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// 
#pragma mark -
@implementation JUMPNSLogTest

//////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// //////////// 
#pragma mark -
#pragma mark Tests

// Run at start of all tests in the class
- (void)setUpClass {
	// Configure the Factory Class.
	[JUMPLoggerConfig setLoggerFactoryClass:[JPNSLogFactory class]];
    // Configure Logger.
    id gettedLogger = [JPNSLogFactory getLogger];
    GHAssertNotNil( gettedLogger, @"Logger wasn't instantiated.");
}

-(void)testLogSomething {
	// Set Level to All.
	SetGlobalLogLevel(JPLoggerAllLevel);

    GHTestLog(@"Should log all levels messages below, please check...");
    Info( @"Logging something on INFO level!!");
    Debug(@"Logging something on DEBUG level!!");
    Warn( @"Logging something on WARN level!!");
    Error(@"Logging something on ERROR level!!");
    Fatal(@"Logging something on FATAL level!!");
}

-(void)testLogSomethingWithExceptions {
	SetGlobalLogLevel(JPLoggerAllLevel);
    NSException *anException = [NSException exceptionWithName:@"testException" reason:@"Some reason" userInfo:nil];
    //
    GHTestLog(@"Should log all levels messages with exception below, please check...");
    ErrorException( anException, @"Logging ERROR with an Exception");
    FatalException( anException, @"Logging FATAL with an Exception");
}

-(void)testChangeLogLevel {
	// Change Log Level to test.
	SetClassLogLevel( JPLoggerOffLevel );
	// Retrieve.
	JPLoggerLevels currentLevel = [[JPNSLogFactory getLoggerForClass:[self class]] currentLevel];
	GHAssertEquals( JPLoggerOffLevel, currentLevel, @"Level wasn't retrieved correctly!!" );
	Debug(@"THIS MESSAGE CANT BE LOGGED!!");
	
	// Change Log Level to test.
	SetClassLogLevel( JPLoggerInfoLevel );
	// Retrieve.
	currentLevel = [[JPNSLogFactory getLoggerForClass:[self class]] currentLevel];
	GHAssertEquals( JPLoggerInfoLevel, currentLevel, @"Level wasn't retrieved correctly!!" );
	Debug(@"THIS MESSAGE CANT BE LOGGED!!");
	Info( @"Logging something on INFO level!!");

}
@end