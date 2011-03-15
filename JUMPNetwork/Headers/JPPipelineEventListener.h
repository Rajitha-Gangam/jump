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
#import "JPPipelineListener.h"

/**
 * @ingroup events_group
 *
 * A Event which represents the notification of an exception
 * raised by a Handler. This event is for
 * going upstream only.
 */
@protocol JPPipelineEventListener
@required

/**
 * Retrieve the Event Listener Object.
 */
-(<JPPipelineListener>)getListener;

/**
 * Set the Event Listener Object.
 */
-(void)setListener:(<JPPipelineListener>)anListener;
@end