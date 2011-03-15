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
#import <Foundation/Foundation.h>
#import "JPPipelineMessageEvent.h"
#import "JPPipelineListener.h"

#import "LoggingExtra.h"

/**
 * @ingroup events_group
 *
 * An <b>Abstract Class</b> that define many methods to one Default Message Event implementation.
 * You should't initiate this class directly, one <b>Exception</b> will be raised if you try so.
 * You should subclass and implement some methods before use it.
 */
@interface JPPipelineSimpleMessageEvent : NSObject <JPPipelineMessageEvent> {
	
	// Message.
	id message;
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Properties.
/// The message associated with this event.
@property (retain, getter=getMessage) id message;

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Init Methods. 
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 

/**
 * Init this event with an message.
 * @param anMessage An message to associate with this event.
 */
+(id)initWithMessage:(id)anMessage;
-(id)initWithMessage:(id)anMessage;

@end
