//
//  PFQuery+NSPredicate.h
//  Parse
//
//  Created by Bryan Klimt on 11/29/12.
//  Copyright (c) 2012 Parse Inc. All rights reserved.
//

#import "PFQuery.h"

@interface PFQuery (NSPredicate)

/*!
 Creates a PFQuery with the constraints given by predicate.
 
 The following types of predicates are supported:
 * Simple comparisons such as =, !=, <, >, <=, >=, and BETWEEN with a key and a constant.
 * Containment predicates, such as "x IN {1, 2, 3}".
 * Key-existence predicates, such as "x IN SELF".
 * BEGINSWITH expressions.
 * Compound predicates with AND, OR, and NOT.
 * SubQueries with "key IN %@", subquery.
 
 The following types of predicates are NOT supported:
 * Aggregate operations, such as ANY, SOME, ALL, or NONE.
 * Regular expressions, such as LIKE, MATCHES, CONTAINS, or ENDSWITH.
 * Predicates comparing one key to another.
 * Complex predicates with many ORed clauses.
 
 */
+ (PFQuery *)queryWithClassName:(NSString *)className predicate:(NSPredicate *)predicate;

@end
