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
#import "JPJSONRPCDecoderHandler.h"

/// /// /// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ///
@implementation JPJSONRPCDecoderHandler

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Init Methods. 
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
- (id) init {
    self = [super init];
    if (self != nil) {
        self.progressPriority = 5;
    }
    return self;
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Process Methods. 
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
// When a JSON data is succesfully decoded this method will be called with the data. 
// You can override this method on a subclass to do some custom processing.
-(void)jsonDataDecoded:(id)JSONDecoded withEvent:(<JPPipelineMessageEvent>)event andContext:(<JPPipelineHandlerContext>)ctx {

    ///////// /////// /////// /////// /////// /////// /////// /////// /////// 
    // If decoded is NIL. Probably we're handling some error, nothing to do here.
    if ( JSONDecoded == nil ) {
        [super jsonDataDecoded:JSONDecoded withEvent:event andContext:ctx];
        return;
    }
    
    ///////// /////// /////// /////// /////// /////// /////// /////// /////// 
	// Create an JSON-PRC Model Object.
    JPJSONRPCModel *model = [JPJSONRPCModel init];
    
    // If some error, we store here.
    NSError *JSONError;
    
	//////// ////// ////// ////// ////// ////// ////// 
	// Check if result some server Error. 
	if( [JSONDecoded objectForKey:@"error"] ) {
		
		// If server error isn't NULL (REAL ERROR), process it.
		if ( [JSONDecoded objectForKey:@"error"] != [NSNull null] ) {
			
			// JSON Error Data.
			NSDictionary *anError = [JSONDecoded objectForKey:@"error"];
			
			// NSError User Info Dictionary.
			NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[anError objectForKey:@"message"] 
                                                                               forKey: NSLocalizedDescriptionKey];
            
			///////// /////// /////// /////// /////// /////// /////// /////// /////// //// /////// 
            // Assign extra JSON-RPC Metadata about this error to the userInfo dictionary.
            
            // Error Name, JSON-RPC 1.1 Compliant.
            if ([anError objectForKey:@"name"]) 
                [userInfo setObject:[anError objectForKey:@"name"] forKey:JPJSONRPCErrorName];    

            // Object value that carries custom and application-specific error information. JSON-RPC 1.1 Compliant.
            if ([anError objectForKey:@"error"]) 
                [userInfo setObject:[anError objectForKey:@"error"] forKey:JPJSONRPCErrorMoreInfo];

            // A Primitive or Structured value that contains additional information about the error. JSON-RPC 2.0 Compliant.
            if ([anError objectForKey:@"data"]) 
                [userInfo setObject:[anError objectForKey:@"data"] forKey:JPJSONRPCErrorData];

			///////// /////// /////// /////// /////// /////// /////// /////// /////// 
			// Create an NSError.
			JSONError = [NSError errorWithDomain:@"JPJSONRPCDecoderHandler"
                                            code:[[anError objectForKey:@"code"] intValue]
                                        userInfo:userInfo];
            
			//////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
			// Log.
			Info( @"JSON Error Handled (%@) | Sending Error Upstream...", [JSONError localizedDescription] );
			
		}
	}
	
	// ////// ////// ////// ////// ////// //////  ////// 
	// JSON doesn't Contains RPC Results. It is invalid.
	else if ( ! [JSONDecoded objectForKey:@"result"] ) {
		NSString *errorReason = @"Invalid JSON-RPC data. JSON Object doesn't contain an 'result' entry.";
		Warn( @"%@", errorReason );
        
        ///////// /////// /////// /////// /////// /////// /////// /////// /////// 
        // Create an NSError.
        JSONError = [NSError errorWithDomain:NSStringFromClass([self class])
                                        code:kJSONRPCInvalid
                                    userInfo:[NSDictionary dictionaryWithObject:errorReason forKey:NSLocalizedDescriptionKey]];
	}
	
    // ////// ////// ////// ////// ////// //////  ////// 
    // Some error formatted?
    if ( JSONError ) {

        // Fail the future.
        [[event getFuture] setFailure:JSONError];

        // Send Error Upstream.
        [ctx sendUpstream:[JPDefaultPipelineExceptionEvent initWithCause:[JPPipelineException initWithReason:[JSONError localizedDescription]]
                                                                andError:JSONError]];
        
        // We're sending a formatted error trough the pipeline. But also sending the full JSON-RPC Model with error and 
        // other data below, maybe some another handler wants to known what to do with that.
        
    }
        
	///////// /////// /////// /////// /////// /////// /////// /////// /////// 
    // Assign data.
    model.theId   = [JSONDecoded objectForKey:@"id"];
    model.result  = [JSONDecoded objectForKey:@"result"];
    model.error   = [JSONDecoded objectForKey:@"error"];
    model.version = [JSONDecoded objectForKey:@"version"]; 
    
	///////// /////// /////// /////// /////// /////// /////// /////// /////// 
	// Super Processing. (Send upstream).
	[super jsonDataDecoded:model withEvent:event andContext:ctx];
}

@end
