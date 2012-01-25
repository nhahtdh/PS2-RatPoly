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

RatTerm* termFromStr(NSString* str) {
    return [RatTerm valueOf:str];
}

RatPoly* poly(NSArray* arr) {
    return [[RatPoly alloc] initWithTerms: arr];
}

RatPoly* polyFromTerm(RatTerm* t) {
    return [[RatPoly alloc] initWithTerm:t];
}

RatPoly* polyFromStr(NSString* str) {
    return [RatPoly valueOf:str];
}

-(void)setUp{
    NaNTerm = [RatTerm initNaN];
    zeroTerm = [RatTerm initZERO];
    zeroPoly = [[RatPoly alloc] init];
    simpleNaN = [[RatPoly alloc] initWithTerm: NaNTerm];
    complexNaN = poly([NSArray arrayWithObjects: termFromStr(@"5/6*x^6"), termFromStr(@"-x^5"), termFromStr(@"NaN*x^2"), termFromStr(@"4"), nil]);
}

-(void)tearDown{
}

-(void)testDefCtor {
    RatPoly *p;
    STAssertNoThrow(p = [[RatPoly alloc] init], @"", @"");
    STAssertEquals(numTerms(p), 0, @"", @"");
    STAssertEquals([p degree], 0, @"", @"");
}

-(void)testInitWithTerm {
    STAssertNoThrow(polyFromTerm(termFromStr(@"3*x^5")), @"", @"");
    STAssertNoThrow(polyFromTerm(termFromStr(@"x")), @"", @"");
    STAssertNoThrow(polyFromTerm(termFromStr(@"-23*x")), @"", @"");
    STAssertNoThrow(polyFromTerm(termFromStr(@"345")), @"", @"");
    STAssertNoThrow(polyFromTerm(termFromStr(@"x^34")), @"", @"");
    STAssertNoThrow(polyFromTerm([RatTerm initZERO]), @"", @"");
    STAssertNoThrow(polyFromTerm(NaNTerm), @"", @"");
    STAssertThrows(polyFromTerm(termFromStr(@"x^-74")), @"", @"");
}

-(void)testGetTerm {
    RatPoly *p = polyFromStr(@"-8/7*x^7+x^5+7*x^4-x+34");
    STAssertEqualObjects([p getTerm:8], zeroTerm, @"", @"");
    STAssertEqualObjects([p getTerm:7], termFromStr(@"-8/7*x^7"), @"", @"");
    STAssertEqualObjects([p getTerm:4], termFromStr(@"7*x^4"), @"", @"");
    STAssertEqualObjects([p getTerm:2], zeroTerm, @"", @"");
    STAssertEqualObjects([p getTerm:0], termFromStr(@"34"), @"", @"");
    
    p = zeroPoly;
    STAssertEqualObjects([p getTerm:1], zeroTerm, @"", @"");
    STAssertEqualObjects([p getTerm:0], zeroTerm, @"", @"");
    
    p = polyFromStr(@"34*x^2-453*x+1");
    STAssertEqualObjects([p getTerm:2], termFromStr(@"34*x^2"), @"", @"");
    STAssertEqualObjects([p getTerm:1], termFromStr(@"-453*x"), @"", @"");
    
    // NaN polynomial is not tested, since degree is not defined for NaN polynomial
}

-(void)testValueOf {
    STAssertEqualObjects(simpleNaN, polyFromStr(@"NaN"), @"", @"");
    STAssertEqualObjects(complexNaN, polyFromStr(@"NaN"), @"", @"");
    STAssertEqualObjects(simpleNaN, polyFromStr(@"-NaN"), @"", @"");
    STAssertEqualObjects(simpleNaN, polyFromStr(@"x^6-NaN*x^5+2"), @"", @"");
    STAssertEqualObjects(polyFromStr(@"0"), zeroPoly, @"", @"");
    STAssertEqualObjects(polyFromStr(@"-NaN*x*56+24"), polyFromStr(@"x^3-NaN*x"), @"", @"");
    STAssertEqualObjects(polyFromStr(@"-x+1"), poly([NSArray arrayWithObjects: termFromStr(@"-x"), termFromStr(@"1"), nil]), @"", @"");
    STAssertEqualObjects(polyFromStr(@"-4*x^2-7"), poly([NSArray arrayWithObjects: termFromStr(@"-4*x^2"), termFromStr(@"-7"), nil]), @"", @"");
    STAssertEqualObjects(polyFromStr(@"34*x^7-45*x^6-x^5+34*x+43"), 
                         poly([NSArray arrayWithObjects: termFromStr(@"34*x^7"), termFromStr(@"-45*x^6"),
                               termFromStr(@"-x^5"), termFromStr(@"34*x"), termFromStr(@"43"), nil]),
                         @"", @"");
}

-(void)testZeroCoeff {
    STAssertThrows(polyFromStr(@"0*x"), @"", @"");
    STAssertThrows(polyFromStr(@"-0*x^34"), @"", @"");
    STAssertThrows(polyFromStr(@"x^5+0*x^4"), @"", @"");
}

-(void)testNegativeExpt {
    STAssertThrows(poly([NSArray arrayWithObjects: termFromStr(@"34*x^-10"), nil]), @"", @"");
    STAssertThrows(poly([NSArray arrayWithObjects: termFromStr(@"-12*x^6"), termFromStr(@"x^-1"), nil]), @"", @"");
}

-(void)testNonDescendingOrder {
    STAssertThrows(polyFromStr(@"-3+x^5"), @"", @"");
    STAssertThrows(polyFromStr(@"NaN-x"), @"", @"");
    STAssertThrows(polyFromStr(@"9*x^15+6*x^4-45*x^3+x^70"), @"", @"");
    STAssertThrows(polyFromStr(@"x^5+x^5+x^4-x"), @"", @"");
}

-(void)testDegree {
    STAssertEquals([polyFromStr(@"34*x^7-45*x^6-x^5+34*x+43") degree], 7, @"", @"");
    STAssertEquals([zeroPoly degree], 0, @"", @"");
    STAssertEquals([polyFromStr(@"-x") degree], 1, @"", @"");
    STAssertEquals([polyFromStr(@"-3453") degree], 0, @"", @"");
    STAssertEquals([polyFromStr(@"-x^45+23*x^4") degree], 45, @"", @"");
    // NaN is not tested, since the degree of a NaN polynomial is undefined.
}

-(void)testNegate {
    STAssertEqualObjects(polyFromStr(@"x"), [polyFromStr(@"-x") negate], @"", @"");
    STAssertEqualObjects(zeroPoly, [zeroPoly negate], @"", @"");
    STAssertEqualObjects(polyFromStr(@"345"), [polyFromStr(@"-345") negate], @"", @"");
    STAssertEqualObjects(polyFromStr(@"34*x^2-453*x+1"), [polyFromStr(@"-34*x^2+453*x-1") negate], @"", @"");
    STAssertEqualObjects(polyFromStr(@"-x^345"), [polyFromStr(@"x^345") negate], @"", @"");
}

-(void)testAddSub {
    STAssertEqualObjects([zeroPoly add:polyFromStr(@"x^3")], polyFromStr(@"x^3"), @"", @"");
    STAssertEqualObjects([polyFromStr(@"2*x") add: zeroPoly], polyFromStr(@"2*x"), @"", @"");
    STAssertEqualObjects([polyFromStr(@"x^3") add: polyFromStr(@"x^2")], polyFromStr(@"x^3+x^2"), @"", @"");
    STAssertEqualObjects([polyFromStr(@"x^3") add: polyFromStr(@"-x^3")], zeroPoly, @"", @"");
    STAssertEqualObjects([polyFromStr(@"4*x^5-3*x^2+6") add: polyFromStr(@"-6*x^5+3*x^2-10")],
                         polyFromStr(@"-2*x^5-4"), @"", @"");
    STAssertEqualObjects([polyFromStr(@"x") sub: polyFromStr(@"-8*x^35")], polyFromStr(@"8*x^35+x"), @"", @"");
    STAssertEqualObjects([zeroPoly add:simpleNaN], simpleNaN, @"", @"");
    STAssertEqualObjects([polyFromStr(@"x^6") add: simpleNaN], simpleNaN, @"", @"");
    STAssertEqualObjects([polyFromStr(@"3/4*x^4-1/2*x+45/23") add:polyFromStr(@"3/5*x^4+1/7*x^2+1/9*x")], 
                         polyFromStr(@"27/20*x^4+1/7*x^2-7/18*x+45/23"), @"", @"");
    
    // There are less test cases for subtraction
    STAssertEqualObjects([polyFromStr(@"x^6") sub: polyFromStr(@"x^6")], zeroPoly, @"", @"");
    STAssertEqualObjects([polyFromStr(@"x^3-2*x^2+3*x") sub: polyFromStr(@"-x^3-2*x^2+x+8")], polyFromStr(@"2*x^3+2*x-8"), @"", @"");
    STAssertEqualObjects([polyFromStr(@"x^4+5*x^3-5") sub: polyFromStr(@"x^8+34")], polyFromStr(@"-x^8+x^4+5*x*3-39"), @"", @"");
    STAssertEqualObjects([polyFromStr(@"-NaN*x^8") sub: polyFromStr(@"3/4*x")], simpleNaN, @"", @"");
    STAssertEqualObjects([polyFromStr(@"-4/5*x^8+x") sub: polyFromStr(@"-5/7*x^8+1/2*x")], polyFromStr(@"-3/35*x^8+1/2*x"), @"", @"");
    STAssertEqualObjects([zeroPoly sub: zeroPoly], zeroPoly, @"", @"");
}

-(void)testMul {
    STAssertEqualObjects([polyFromStr(@"0") mul: polyFromStr(@"-8*x^3+7*x^2")], zeroPoly, @"", @"");
    STAssertEqualObjects([polyFromStr(@"7/5*x^5-NaN*x^4+x") mul: polyFromStr(@"x^3-6*x")], simpleNaN, @"", @"");
    STAssertEqualObjects([polyFromStr(@"x^2-4/5*x-1/9") mul: polyFromStr(@"-3*x^4+5/6")], 
                         polyFromStr(@"-3*x^6+12/5*x^5+1/3*x^4+5/6*x^2-2/3*x-5/54"), @"", @"");
    STAssertEqualObjects([polyFromStr(@"-x^2+4*x+7") mul: polyFromStr(@"-4*x^2+7*x-3")], polyFromStr(@"4*x^4-23*x^3+3*x^2+37*x-21"), @"", @"");
}

-(void)testDiv{
    STAssertEqualObjects([polyFromStr(@"-x^2-5/4*x") div: polyFromStr(@"4*x^5")], zeroPoly, @"", @"");
    STAssertEqualObjects([polyFromStr(@"x^3-1") div: polyFromStr(@"x-1")], polyFromStr(@"x^2+x+1"), @"", @"");
    STAssertEqualObjects([polyFromStr(@"x^3+7") div: polyFromStr(@"x^2-2/3*x+3/4")], polyFromStr(@"x+2/3"), @"", @"");
    STAssertEqualObjects([poly([NSArray arrayWithObjects: termFromStr(@"7/5*x^5"), termFromStr(@"NaN*x^4"), termFromStr(@"-x"), nil]) 
                            div: polyFromStr(@"x^3-6*x")],
                         simpleNaN, @"", @"");
    STAssertEqualObjects([polyFromStr(@"x^5-4/5*x") div: zeroPoly], simpleNaN, @"", @"");
    STAssertEqualObjects([zeroPoly div: polyFromStr(@"-3*x^5-7/8")], zeroPoly, @"", @"");
}

-(void)testEval {
    
}

@end