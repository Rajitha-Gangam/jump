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
#import "JPDataConverter.h"

// Static Properties.
static NSMutableArray* _JPDataConverterKnowedDateFormats;

////////////// ////////////// ////////////// ////////////// 
@implementation JPDataConverter

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Private Methods.
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// /
// Build default knowed date formats.
+(void)buildDefaultKnowedFormats {
	[self setKnowedDateFormats:[NSMutableArray arrayWithObjects:
												@"yyyy-MM-dd HH:mm:ss", 
												@"yyyy-MM-dd",
												@"YYYY-MM-DD HH:MM:SS ±HHMM", nil]
	];
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Setters and Getters.
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// /
+(void)setKnowedDateFormats:(NSMutableArray*)knowedDateFormats {
	// If are the same, do nothing.
	if ( _JPDataConverterKnowedDateFormats == knowedDateFormats )
		return;
	
	// Release if exists.
	if ( _JPDataConverterKnowedDateFormats != nil ) 
		[_JPDataConverterKnowedDateFormats release];
	
	// Retain it.
	_JPDataConverterKnowedDateFormats = [knowedDateFormats retain];
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// /
+(NSMutableArray*)knowedDateFormats {
	// Create if doesn't exist.
	if ( _JPDataConverterKnowedDateFormats == nil ) 
		[self buildDefaultKnowedFormats];

	// Return it.
	return _JPDataConverterKnowedDateFormats;
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// /
#pragma mark -
#pragma mark Convert Methods. 
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// ///

////////////// ////////////// ////////////// ////////////// 
//  Take an NSNumber or NSString Object and try to convert to NSDate.
+(NSDate*)convertToNSDateThisObject:(id)anObject {
	return [self convertToNSDateThisObject:anObject withAdditionalDateFormat:nil];
}

////////////// ////////////// ////////////// ////////////// 
//  Take an NSNumber or NSString Object and try to convert to NSDate.
+(NSDate*)convertToNSDateThisObject:(id)anObject withAdditionalDateFormat:(NSString*)anDateFormatter {
	// Knowed date formats. This is used to test against this types to try to convert automagically.
	NSArray *knowedDateFormats = [self knowedDateFormats];
	
	// Loop on knowed types, trying to figure out one of then.
	for ( NSString* dateFormat in knowedDateFormats ) {
		NSDate *converted = [self convertToNSDateThisObject:anObject withDateFormat:dateFormat];
		
		// If convert ok, return.
		if ( converted ) return converted;
		
		// If don't, try next one.
	}
	
	// If can't convert. Return nil.
	return nil;
}

////////////// ////////////// ////////////// ////////////// 
//  Take an NSNumber or NSString Object and try to convert to NSDate.
+(NSDate*)convertToNSDateThisObject:(id)anObject withDateFormat:(NSString*)anDateFormatter {	
	// Create an Date Formatter.
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:anDateFormatter];
	
	// Convert from NSString to NSDate.
	if ( [anObject isKindOfClass:[NSString class]] ) 
		return [dateFormatter dateFromString:anObject];
	
	// Convert from NSNumber to NSDate.
	if ( [anObject isKindOfClass:[NSNumber class]] ) 
		return [NSDate dateWithTimeIntervalSinceNow:[anObject doubleValue]];
	
	// Can't convert, return NIL.
	return nil;
}

////////////// ////////////// ////////////// ////////////// 
// Take an NSString Object and try to convert to NSNumber.
+(NSNumber*)convertToNSNumberThisObject:(id)anObject {
	
	// Convert from NSString to NSNumber.
	if ( [anObject isKindOfClass:[NSString class]] ) {
		
		// Create an Scanner, the scaner will scan the string looking for specific type number.
		NSScanner *stringScanner = [NSScanner scannerWithString:anObject];
		
		// Scan string looking for INT.
		int aInt; 
		if ( [stringScanner scanInt:&aInt] )
			return [NSNumber numberWithInt:[anObject intValue]];
		
		// Scan string looking for FLOAT.
		float aFloat; 
		if ( [stringScanner scanFloat:&aFloat] )
			return [NSNumber numberWithFloat:[anObject floatValue]]; 
		
		// Scan string looking for DOUBLE.
		double aDouble;
		if ( [stringScanner scanDouble:&aDouble] ) 
			return [NSNumber numberWithDouble:[anObject doubleValue]]; 
	}		
	
	// Can't convert, return NIL.
	return nil;
}

////////////// ////////////// ////////////// /////// //// //// //// //// /
// Take an NSNumber or NSDate Object and try to convert to NSString.
+(NSString*)convertToNSStringThisObject:(id)anObject {
	
	// Convert from NSNumber to NSString.
	if ( [anObject isKindOfClass:[NSNumber class]] ) 
		return [anObject stringValue];
	
	// Convert from NSDate to NSString.
	if ( [anObject isKindOfClass:[NSDate class]] ) 
		return [NSDate description];
	
	// Can't convert, return NIL.
	return nil;
	
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// /
// This method convert an Java Util Date Dictionary to NSDate.
+(id)convertFromJavaUtilDateIfNeeded:(id)anObject {
	
	// If object is one dictionary.
	if ( [ anObject isKindOfClass:[NSDictionary class]] ) {
		
		// Check for the key : javaClass
		if ( [anObject objectForKey:@"javaClass"] ) {
			
			// Check for value. java.util.Date (JSON Date Object, using this convetion: http://weblogs.asp.net/bleroy/archive/2008/01/18/dates-and-json.aspx
			if ( [[anObject objectForKey:@"javaClass"] isEqual:@"java.util.Date"] ) {

				return [NSDate dateWithTimeIntervalSince1970:[ [anObject objectForKey:@"time"] doubleValue] / 1000 ];
				
			}
		}
	}
	
	// If nothing of it, return object without touch..
	return anObject;
	
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// /

@end
