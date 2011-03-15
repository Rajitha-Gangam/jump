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
#import "JPCore.h"
#import "JPDBManager.h"
#import "JPDBManagerAction.h"

///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// 
#pragma mark Implementation.
@implementation JPDBManager

///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// 
#pragma mark -
#pragma mark Properties.
///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// 
@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator;
@synthesize automaticallyCommit;

////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
#pragma mark -
#pragma mark Init Methods.
////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
// Init.
- (id) init {
	self = [super init];
	if (self != nil) {		
		
		// Nothing to do here until now.
		
	}
	return self;
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
// Init Autoreleseable.
+(id)init {
	return [[[self alloc] init] autorelease];
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// ///
// Init and Alloc the Database Manager Class. 
// Automatically Start all Core Data Engine.
+(id)initAndStartCoreData {
	JPDBManager *instance = [self init];
	[instance startCoreData];
	
	// Return Instaciated.
	return instance;
}
	
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Memory Management Methods. 
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
- (void) dealloc {
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	[loadModelNamed release];
	[super dealloc];
}

////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
#pragma mark -
#pragma mark Notifications Methods.
////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
-(void)notificateError:(NSError*)anError {
	
	// Create an Notification.
	NSNotification *anNotification = [NSNotification notificationWithName:JPDBManagerErrorNotification 
																   object:anError 
																 userInfo:[NSDictionary dictionaryWithObject:self forKey:JPDBManagerErrorNotification]];
	// Post notification.
	[[NSNotificationCenter defaultCenter] postNotification:anNotification];
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Private Methods. 
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
-(void)throwExceptionWithCause:(NSString*)anCause {
	[NSException raise:JPDBManagerActionException format:@"%@", anCause];
}
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// /
-(void)throwIfNilObject:(id)anObject withCause:(NSString*)anCause {
	if ( anObject == nil ) 
		[self throwExceptionWithCause:anCause];
}
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Start and Stop Methods.
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 

////// ////// ////// ////// ////// ////// 
// Start Core Data Database.
-(id)startCoreData {
	[self managedObjectContext];
	return self;
}

////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
// Start Core Data Databases. Using an specific model.
-(id)startCoreDataWithModel:(NSString*)modelName {
	//LogWhereCommentTo(SEQOYDBManager, NSFormatString( @"Starting Core Data Using Model: [[%@]]", modelName) );
	
	// Dealloc if needed and set.
	if ( loadModelNamed ) [loadModelNamed release], loadModelNamed = nil;
	loadModelNamed = [modelName copy];
	
	// Continue.
	[self startCoreData];
	
	// Return ourselves.
	return self;
}

////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
// Close Core Data Database.
-(void)closeCoreData {
	
	////// ////// ////// ////// ////// ////// ////// ////// ////// 
	// Commit data.
	[self commit];
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
-(JPDBManagerAction*)getDatabaseAction {
	JPDBManagerAction *instance = [JPDBManagerAction initWithManager:self];
	instance.commitTransaction = self.automaticallyCommit;
	return instance;
}

////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
#pragma mark -
#pragma mark Core Data Stack (Private Methods).
////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
//
// Returns the path to the application's documents directory.
//
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	
    return basePath;
}
////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
//
// Create missing relationships bewtween Entities. 
//
// Returns the managed object model merged.
//
- (NSManagedObjectModel *)createMissingRelationships:(NSManagedObjectModel *)model {
	//LogWhereCommentTo(SEQOYDBManager, @"Create Missing Relationships Between Entities")
	
	// One List of all Entities (Tables).
	NSDictionary *allTables = [model entitiesByName];
	
	////// ////// ////// ////// ////// ////// ////// 
	
	// Loop on All Entities that is not from mainDatabase.
	for (NSEntityDescription *entity in [model entitiesForConfiguration:@"moduleDatabase"]) {
		
		// Loop em todos os Relationships, se não tem não vai fazer nada.
		for ( NSString *relationName in [entity relationshipsByName] ) {
			
			// Pega o Relationship que vamos trabalhar.
			NSRelationshipDescription *workingRelationship = [[entity relationshipsByName] objectForKey:relationName];
			
			// Processa se esse Relationship está configurada para ser processado.
			if ( [[workingRelationship userInfo] objectForKey:@"RelationshipWithEntity"] ) {
				
				// Pega a tabela que essa propriedade irá se relacionar.
				NSEntityDescription *pointToTable = [allTables objectForKey:[[workingRelationship userInfo] objectForKey:@"RelationshipWithEntity"] ];
				
				// Se a tabela NAO EXISTE imprime erro e corta o programa.
				if ( pointToTable == nil ) {
					
					// Handle error.
					NSString *errorMessage = NSFormatString( @"Trying to create missing relationship on moduleDatabase: %@. Missing relationship tells to point to entity: %@. But this entity doesn't exist.", [entity name], [[workingRelationship userInfo] objectForKey:@"RelationshipWithEntity"]); 
					
					// Error Message and Crash the System. 
					[NSException raise:JPDBManagerStartException format:@"%@", errorMessage];
				}
				
				// Modifica a propriedade apontando a tabela correta.
				[workingRelationship setDestinationEntity:pointToTable]; 
				
				////// ////// ////// ////// ////// ////// 
				
				// Prepara a versão inversa dessa propriedade para colocar na tabela que aponta.
				NSRelationshipDescription *inverseProperty = [[NSRelationshipDescription alloc] init];
				
				[inverseProperty setName:[entity name]];
				[inverseProperty setOptional:[workingRelationship isOptional]];
				[inverseProperty setTransient:[workingRelationship isTransient]];
				[inverseProperty setDestinationEntity:entity ];
				[inverseProperty setInverseRelationship:workingRelationship ];
				[inverseProperty setMaxCount:[workingRelationship maxCount]];
				[inverseProperty setMinCount:[workingRelationship minCount]];
				[inverseProperty setDeleteRule:NSNoActionDeleteRule];
				
				// Pega uma cópia mutável das propriedades já existentes e adiciona a que recém criamos.
				NSMutableArray *mainTableExistingProperties = [[NSMutableArray alloc] initWithArray:[pointToTable properties] ];
				[mainTableExistingProperties insertObject:inverseProperty atIndex:0];
				
				// Adiciona todas as propriedades de volta.
				[pointToTable setProperties:mainTableExistingProperties ];
				
				// Release.
				[mainTableExistingProperties release];
				
				////// ////// ////// ////// ////// ////// 
				
				// Modifica a propriedade apontando a tabela principal.
				[workingRelationship setInverseRelationship:inverseProperty];
				
				// Release.
				[inverseProperty release];
			}
			
			// Release.
			[workingRelationship release]; 
		}
	}
	
	// Retorna Modelo Montado.
    return model;
	
}


////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
//
// Managed Object Model Accessor. If the model doesn't already exist, it is created by merging all of
// the models found in the application bundle.
//
// Returns the managed object model for the application.
//
- (NSManagedObjectModel *)managedObjectModel {
	//LogWhereCommentTo(SEQOYDBManager, @"Init The Managed Object Model.")
	
	// Return Managed Object Model if is already started...
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
	////// ////// ////// ////// ////// ////// ////// ////// ////// ////// //////
	// If defined an Model Name, search for him on bundle.
	if ( loadModelNamed ) {
		NSString *modelPath = [[NSBundle mainBundle] pathForResource:[[loadModelNamed lastPathComponent] stringByDeletingPathExtension]
															  ofType:[loadModelNamed  pathExtension]];
		////// ////// ////// ////// ////// ////// ////// ////// ////// //////
		// If can't found, trhow error.
		if ( _NOT_ modelPath ) {

			// Error Message and Crash the System. 
			[NSException raise:JPDBManagerStartException
						format: @"Informed Model: %@.xcdatamodeld (mom/momd) **NOT FOUND on bundle.", loadModelNamed];
		}

		////// ////// ////// ////// ////// ////// //////
		// Alloc and Init.
		managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath: modelPath]];
	}
	
	////// ////// ////// ////// ////// ////// ////// ////// ////// ////// //////
	// If isn't specified...
	// Merge all models found in the application bundle. Will Create the missing Relation Between then if needed.
	else {
		managedObjectModel = [ [self createMissingRelationships:[NSManagedObjectModel mergedModelFromBundles:nil] ] retain];
	}
	
	// Return Managed Object Model.
    return managedObjectModel;
}

////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
//
// persistentStoreCoordinator
//
// Accessor. If the coordinator doesn't already exist, it is created and the
// application's store added to it.
//
// Returns the persistent store coordinator for the application.
//
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	//LogWhereCommentTo(SEQOYDBManager, @"Init Persitent Store Coordinator" )
	
	// Return Persistent Coordinator if is already started...
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	////// ////// ////// ////// ////// ////// ////// ////// ////// ////// //////
	
	// Main Database Path.
    NSURL *mainDatabase = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"mainDatabase.JPlite"]];
	
	// Error Control.
	NSError *error = nil;
	
	////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// //////
	// Alloc and Init Persistent Coordinator.
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// //////
	//
	// Options to pass to persistent store. http://developer.apple.com/iphone/library/documentation/Cocoa/Conceptual/CoreDataVersioning/Articles/vmMappingOverview.html
	//
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
			 
			  // Automatically attempt to migrate versioned stores.				 
			 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,	
							 
			 // Attempt to create the mapping model automatically.
			 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// //////
	// Add JPL to the Persistent, control error above.
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
												  configuration:nil
															URL:mainDatabase
														options:options 
														  error:&error]) {
		
		////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// //////
        // Handle error.
		
		// Error Message and Crash the System. 
		[NSException raise:JPDBManagerStartException
					format: @"Unsolved Error: (%@), (%@).", error, [error userInfo]];
    }    
	
	// Return Persistent Coordinator.
    return persistentStoreCoordinator;
}
////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// 
//
// Managed Object Context Accessor. If the context doesn't already exist, it is created and bound to
// the persistent store coordinator for the application.
//
// Returns the managed object context for the application.
//
- (NSManagedObjectContext*)managedObjectContext {
	//LogWhereCommentTo(SEQOYDBManager, @"Init Managed Object Context")
	
	// Return Managed Object Context if is already started...
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
	////// ////// ////// ////// ////// ////// ////// ////// ////// ////// //////
	
	// Grab the Coordinator.
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	
	// If not exist...
    if (coordinator != nil) {
		
		// Alloc and Start.
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
	
	// Return.
    return managedObjectContext;
}


//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Checking Methods. 
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 

////// ////// ////// ////// ////// ////// ////// ////// 
// Return YES if specified Entity exist on the model.
-(BOOL)existEntity:(NSString*)anEntityName {
	
	// Try to retrieve the Entity.
	NSEntityDescription *entity = [NSEntityDescription entityForName:anEntityName inManagedObjectContext:managedObjectContext];
	
	// Not Exist.
	if ( _NOT_ entity ) {	
		//Warn( @"JPDatabaseManager : The Entity '%@' doesn't exist on any Model.", anEntityName );
		return NO;
	}
	
	// Exist.
	return YES;
}

////// ////// ////// ////// ////// ////// 
// Return YES if specified Attribute exist on specified Entity.
-(BOOL)existAttribute:(NSString*)anAttributeName inEntity:(NSString*)anEntityName {
	
	// If NOT Exist Entity retun NO;
	if ( _NOT_ [self existEntity:anEntityName] )
		return NO;
	
	// Retrieve the Entity.
	NSEntityDescription *entity = [NSEntityDescription entityForName:anEntityName inManagedObjectContext:managedObjectContext];
	
	// Test if exist this attribute.
	if ( _NOT_ [ [entity attributesByName] objectForKey:anAttributeName] ) {	
		//Warn( @"JPDatabaseManager : The Attribute/Key '%@' doesn't exist in Entity '%@'.", anAttributeName, anEntityName );
		return NO;
	}
	
	return YES;
	
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Database Action Methods. 
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
// This method is called from the JPDBManagerAction as an private call. 
-(id)performDatabaseActionInternally:(JPDBManagerAction*)anAction {
	
	// Can't be nil.
	[self throwIfNilObject:anAction withCause:@"Can't perform an Database Action because an Action wasn't passed."];

	//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	// Put on Variables.
	NSString* anEntityName				 = [anAction entity];
	NSString* anFetchName				 = [anAction fetchTemplate];
	NSDictionary* variablesListAndValues = [anAction variablesListAndValues];
	NSArray* anArrayOfSortDescriptors	 = [anAction sortDescriptors];
	NSPredicate* anPredicate			 = [anAction predicate];

	//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	// Check Parameters.
	NSString *throwMessage = @"Can't perform an Database Action because the '%@' property isn't setted.";
	[self throwIfNilObject:anEntityName withCause:NSFormatString( throwMessage, @"entity" )];

	/// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	// Format Log.
	NSMutableString *format = [NSMutableString stringWithString:NSFormatString( @"Querying {%@}", anEntityName )];
	if ( anFetchName ) 
		[format appendString:NSFormatString( @", TEMPL:(%@)", anFetchName )];
	//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	if ( anPredicate ) {
		NSString *predicateLiteral = [anPredicate predicateFormat];
		[format appendString:NSFormatString( @", PREDIC:(%@%@)", [predicateLiteral substringWithRange:(NSRange){0,([predicateLiteral length] > 50 ? 50 : [predicateLiteral length])}], ([predicateLiteral length] > 50 ? @"..." : @""))];
	}
	//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	if ( anArrayOfSortDescriptors _AND_ [anArrayOfSortDescriptors count] > 0) {
		[format appendString:@", ORD: "];
		for ( NSString *key in anArrayOfSortDescriptors ) {
			[format appendString:NSFormatString( @"%@, ", key)];
		}
	}
	//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	//LogTo(SEQOYDBManagerOperations, @"%@", format);
	/// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
		
	/// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	// If doesn't exist the Entity, return nothing.
	if ( _NOT_ [self existEntity:anEntityName] ) {
		[self throwExceptionWithCause:NSFormatString( @"The Entity '%@' doesn't exist on any Model.", anEntityName )];
		return nil;
	}
	
	// Get the Entity.
	NSEntityDescription *entity = [NSEntityDescription entityForName:anEntityName inManagedObjectContext:managedObjectContext];

	//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	
	//// //// //// //// //// //// //// //// //// //// //// /
	// Create the Fetch Request.
	NSFetchRequest *query = [[[NSFetchRequest alloc] init] autorelease];

	//// //// //// //// //// //// //// //// //// //// //// /	
	// Try to use an Fetch Template, if defined.
	if ( anFetchName ) {
		
		//// //// //// //// //// //// //// //// //// //// //// /	
		// Fetch Template, replacing variables, if defined...
		if ( variablesListAndValues ) {
			query = [managedObjectModel fetchRequestFromTemplateWithName:anFetchName substitutionVariables:variablesListAndValues];
			
		} 
		
		//// //// //// //// //// //// //// //// //// //// //// /	
		// ..if not, just get the fetch template.
		else						  [query setPredicate:[managedObjectModel fetchRequestTemplateForName:anFetchName].predicate];
		
		//// //// //// //// //// //// //// //// //// //// //// /	
		// Not Exist.
		if ( _NOT_ query ) {
			[self throwExceptionWithCause:NSFormatString( @"The Fetch Template '%@' for Entity '%@' doesn't  exist on the Model.", anFetchName, anEntityName )];
			return nil;
		}	

	}
		
	//// //// //// //// //// //// //// //// //// //// //// ///// //// //// //// //// //// //// //// //// //// //// /		
	// If have one defined predicate (parameter). Insert on the query.
	else if ( anPredicate ) 
		[query setPredicate:anPredicate];

	//// //// //// //// //// //// //// //// //// //// //// ///// //// //// //// //// //// //// //// //// //// //// /
	// Can't perform with no predicates.
	else {
		[self throwExceptionWithCause:NSFormatString( throwMessage, @"fetchRequest' or 'predicate" )];
	}
	
	//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	// Set Order if defined.
	if ( anArrayOfSortDescriptors )
		[query setSortDescriptors:anArrayOfSortDescriptors];
	
	//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	// Apply Settings.
	[query setReturnsObjectsAsFaults:[anAction returnObjectsAsFault]];			// Fault Lines?
	[query setEntity:entity];													// Set Entity.
	
	// Apply Limits.
	[query setFetchLimit:[anAction limitFetchResults]];
	[query setFetchOffset:[anAction startFetchInLine]];
	
	//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	// Error Control.
	NSError *error = nil;
	
	//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
	// Return Data as Arrays.
	if ( [anAction returnActionAsArray] ) {

		// Run Fetch (SELECT).
		id queryResult = [managedObjectContext executeFetchRequest:query error:&error];	
		
		// Notificate the error.
		if ( error ) 
			[self notificateError:error];
		
		// Return data.
		return queryResult;
	}

	// Return Data as NSFetchedResultsController.
	else {
		return [[NSFetchedResultsController alloc] initWithFetchRequest:query 
												   managedObjectContext:managedObjectContext
													 sectionNameKeyPath:nil
															  cacheName:nil];
	}
	
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
// Thread Unsafe Database Action.
-(id)performDatabaseAction:(JPDBManagerAction*)anAction {
	return [self performDatabaseActionInternally:anAction];
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
// Thread Safe Database Action.
-(id)performThreadSafeDatabaseAction:(JPDBManagerAction*)anAction {
	// Syncronized call, so this is an thread safe operation.
	@synchronized( anAction ) {
		return [self performDatabaseActionInternally:anAction];
	}
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Write Data Methods. 
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //
// Commit al pendent operations to the persistent store.
-(void)commit {
	//LogWhereCommentTo(SEQOYDBManager, @"Saving Changes To Database.")
	
	// Error Control.
	NSError *anError = nil;
	
	//// //// //// //// //// //// //// /////// //// //// //// //// //// //// ///
	// Performs the commit action for the application, which is to send
	// the save: message to the Application's Managed Object Context.
	if ( ! [[self managedObjectContext] save:&anError] ) {
		//Warn( @"Commit Error: %@.\n\n. Full Error Description:\n\n %@", [anError localizedDescription], anError );
		
		// Notificate the error.
		[self notificateError:anError];
	}
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //
// Create and return a new empty Record for specified Entity.
-(id)createNewRecordForEntity:(NSString*)anEntityName {
	//LogWhereCommentTo(SEQOYDBManager, NSFormatString( @"Creating New Record For Entity:[[%@]] %@", anEntityName, (commitAllTransactions ? @"[COMMIT]" : @"") ) )
	
	// If not exist, return nothing.
	if ( _NOT_ [self existEntity:anEntityName] ) 
		return nil;
	
	// Create and return a new record.
	id newRecord = [NSEntityDescription insertNewObjectForEntityForName:anEntityName
												 inManagedObjectContext:managedObjectContext];	
	
	// Return created object.
	return newRecord;
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark Remove Data Methods. 
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
// Delete an record of database. Use the Default Setting to Commit Automatically decision.
-(void)deleteRecord:(id)anObject {
	[[self managedObjectContext] deleteObject:anObject];
}

@end
///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// 


/*** NOT USED CODE --
 
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
#pragma mark NSManagedObjectContext Addition.
//// //// //// //// //// //// //// //// ////	//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
@implementation NSManagedObjectContext(JPDatabaseAdditions)
// Correction of 'NSInternalInconsistencyException', reason: 'binding not implemented for this JPLType 7'
// More details: http://lists.apple.com/archives/cocoa-dev/2009/Sep/msg01381.html
- (BOOL)safeSave:(NSError**)error {
	// Control success.
	BOOL success = YES;
	
	// Only process if actually have changes.
	if ([self hasChanges]) {
		for (id object in [self updatedObjects]) {
			if (![[object changedValues] count]) {
				[self refreshObject: object
					   mergeChanges: NO];
			}
		}
		
		// Error control.
		if (![self save:error]) {
			success = NO;
		}
	}
	
	// Return.
	return success;
}
@end

*/