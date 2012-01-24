//
//  RatPolyTests.m
//  RatPolyCalculator
//
//  Created by LittleApple on 1/11/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

/* skeleton unit test implementation */

#import "RatPolyTests.h"


@implementation RatPolyTests

int numTerms(RatPoly* poly) {
    return (int) poly.terms.count;
}

-(void)setUp{
}

-(void)testDefCtor {
    RatPoly *poly = [[RatPoly alloc] init];
    STAssertEquals(numTerms(poly), 0, @"", @"");
    STAssertEquals([poly degree], 0, @"", @"");
}

-(void)tearDown{
}

@end