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
#import "JPPipelineEventListener.h"

/// /// /// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ///
@protocol JPPipelineFuture;

/**
 * @ingroup events_group
 *
 * \copydoc events_page
 *
 */
@protocol JPPipelineEvent	

/**
 * Returns the Future Object which is associated with this event.
 * If this event is an upstream event, this method will always return a
 * SucceededPipelineFuture because the event has occurred already.
 * If this event is a downstream event (i.e. I/O request), the returned
 * future will be notified when the I/O request succeeds or fails.
 */
-(<JPPipelineFuture>)getFuture;

@end