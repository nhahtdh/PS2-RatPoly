#import "RatPoly.h"


@implementation RatPoly

@synthesize terms;

// Note that since there is no variable called "degree" in our class,the compiler won't synthesize 
// the "getter" for "degree". and we have to write our own getter
-(int)degree{ // 5 points
    // EFFECTS: returns the degree of this RatPoly object. 
    
	//i'm just a skeleton here, do fill me up please, or
	//I'll throw an exception to remind you of my existence. muahaha
	[NSException raise:@"RatPoly degree not implemented" format:@"fill me up plz!"];
}

// Check that the representation invariant is satisfied
-(void)checkRep{ // 5 points
	//i'm just a skeleton here, do fill me up please, or
	//I'll throw an exception to remind you of my existence. muahaha
	[NSException raise:@"RatPoly checkRep not implemented" format:@"fill me up plz!"];
}

-(id)init { // 5 points
    //EFFECTS: constructs a polynomial with zero terms, which is effectively the zero polynomial
    //           remember to call checkRep to check for representation invariant
    
}

-(id)initWithTerm:(RatTerm*)rt{ // 5 points
    //  REQUIRES: [rt expt] >= 0
    //  EFFECTS: constructs a new polynomial equal to rt. if rt's coefficient is zero, constructs
    //             a zero polynomial remember to call checkRep to check for representation invariant
    
    
}

-(id)initWithTerms:(NSArray*)ts{ // 5 points
    // REQUIRES: "ts" satisfies clauses given in the representation invariant
    // EFFECTS: constructs a new polynomial using "ts" as part of the representation.
    //            the method does not make a copy of "ts". remember to call checkRep to check for representation invariant
    
    
}

-(RatTerm*)getTerm:(int)deg { // 5 points
    // REQUIRES: self != nil && ![self isNaN]
    // EFFECTS: returns the term associated with degree "deg". If no such term exists, return
    //            the zero RatTerm
    
}

-(BOOL)isNaN { // 5 points
    // REQUIRES: self != nil
    //  EFFECTS: returns YES if this RatPoly is NaN
    //             i.e. returns YES if and only if some coefficient = "NaN".
    
}


-(RatPoly*)negate { // 5 points
    // REQUIRES: self != nil 
    // EFFECTS: returns the additive inverse of this RatPoly.
    //            returns a RatPoly equal to "0 - self"; if [self isNaN], returns
    //            some r such that [r isNaN]
    
}


// Addition operation
-(RatPoly*)add:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self+p; if [self isNaN] or [p isNaN], returns
    //            some r such that [r isNaN]
    
}

// Subtraction operation
-(RatPoly*)sub:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self-p; if [self isNaN] or [p isNaN], returns
    //            some r such that [r isNaN]
    
}


// Multiplication operation
-(RatPoly*)mul:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self*p; if [self isNaN] or [p isNaN], returns
    // some r such that [r isNaN]
    
}


// Division operation (truncating).
-(RatPoly*)div:(RatPoly*)p{ // 5 points
    // REQUIRES: p != null, self != nil
    // EFFECTS: return a RatPoly, q, such that q = "this / p"; if p = 0 or [self isNaN]
    //           or [p isNaN], returns some q such that [q isNaN]
    //
    // Division of polynomials is defined as follows: Given two polynomials u
    // and v, with v != "0", we can divide u by v to obtain a quotient
    // polynomial q and a remainder polynomial r satisfying the condition u = "q *
    // v + r", where the degree of r is strictly less than the degree of v, the
    // degree of q is no greater than the degree of u, and r and q have no
    // negative exponents.
    // 
    // For the purposes of this class, the operation "u / v" returns q as
    // defined above.
    //
    // The following are examples of div's behavior: "x^3-2*x+3" / "3*x^2" =
    // "1/3*x" (with r = "-2*x+3"). "x^2+2*x+15 / 2*x^3" = "0" (with r =
    // "x^2+2*x+15"). "x^3+x-1 / x+1 = x^2-x+2 (with r = "-3").
    //
    // Note that this truncating behavior is similar to the behavior of integer
    // division on computers.
    
}

-(double)eval:(double)d { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns the value of this RatPoly, evaluated at d
    //            for example, "x+2" evaluated at 3 is 5, and "x^2-x" evaluated at 3 is 6.
    //            if [self isNaN], return NaN
    
    
}


// Returns a string representation of this RatPoly.
-(NSString*)stringValue { // 5 points
    // REQUIRES: self != nil
    // EFFECTS:
    // return A String representation of the expression represented by this,
    // with the terms sorted in order of degree from highest to lowest.
    //
    // There is no whitespace in the returned string.
    //        
    // If the polynomial is itself zero, the returned string will just
    // be "0".
    //         
    // If this.isNaN(), then the returned string will be just "NaN"
    //         
    // The string for a non-zero, non-NaN poly is in the form
    // "(-)T(+|-)T(+|-)...", where "(-)" refers to a possible minus
    // sign, if needed, and "(+|-)" refer to either a plus or minus
    // sign, as needed. For each term, T takes the form "C*x^E" or "C*x"
    // where C > 0, UNLESS: (1) the exponent E is zero, in which case T
    // takes the form "C", or (2) the coefficient C is one, in which
    // case T takes the form "x^E" or "x". In cases were both (1) and
    // (2) apply, (1) is used.
    //        
    // Valid example outputs include "x^17-3/2*x^2+1", "-x+1", "-1/2",
    // and "0".
    
}


// Builds a new RatPoly, given a descriptive String.
+(RatPoly*)valueOf:(NSString*)str { // 5 points
    // REQUIRES : 'str' is an instance of a string with no spaces that
    //              expresses a poly in the form defined in the stringValue method.
    //              Valid inputs include "0", "x-10", and "x^3-2*x^2+5/3*x+3", and "NaN".
    // EFFECTS : return a RatPoly p such that [p stringValue] = str
    
}

// Equality test
-(BOOL)isEqual:(id)obj { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns YES if and only if "obj" is an instance of a RatPoly, which represents
    //            the same rational polynomial as self. All NaN polynomials are considered equal
    
}

@end

/* 
 
 Question 1(a)
 ========
 
 Let us define the negation operation: r = -p
 set r = p by making a term-by-term copy of all terms of p into r
 foreach term tr in r:
    negate the coefficient of tr
 
 The subtraction operation: r = p - q can then be defined:
 set r = -q by applying negation operation
 set r = r + p by applying addition operation
 
 Question 1(b)
 ========
 
 r = p * q
 set r = zero polynomial
 foreach term tp in p:
    set m = zero polynomial
    for each term tq in q:
        insert new term tm whose coefficient is the product
        of the coefficient of tp and tq, and exponent is 
        the sum of the exponent of tp and tq
    set r = r + m by applying addition operation
        
 Question 1(c)
 ========
 
 q = u / v
 set q = zero polynomial
 set m = p by making a term-by-term copy of all term of u into m
 while degree of m is larger than or equal to degree of v
    let tm be the term with the largest exponent in m
    let tv be the term with the largest exponent in v
    insert new term tq whose coefficient is the quotient of 
    the coefficients of tm and tv and exponent is the difference
    between the exponents of tm and tv
    set d = (quotient of coefficents of tm and tv) * v
    set m = m - d;
 
 
 Question 2(a)
 ========
 
 We requires self to be non-null because we can pass message to the
 pointer even before the pointer is allocated (nil pointer).
 In Objective-C, sending a message to nil will do nothing, as opposed to
 exception being thrown in Java or segmentation fault in a C/C++ program.
 div checks whether the RatNum is NaN or not, while add and mul does not
 because add and mul operation will returns a NaN RatNum if any of the 
 argument is NaN, while div operation may not without the if clause (e.g.
 a normal RatNum with rep 3/4 divides with a NaN RatNum with the rep 1/0,
 without the checking will result in the creation of RatNum with the value
 0).
 
 Question 2(b)
 ========
 
 valueOf is a class method because it is related to object creation, there
 is no need for an existing object to involve in the process.
 init method is an alternative to class method that can accomplish the same
 goal.
 
 Question 2(c)
 ========
 
 List of functions that need to be changed:
 checkRep: remove the whole clause: if (denom > 0) { ... }
 
 
 Question 2(d)
 ========
 
 <Your answer here>
 
 Question 3(a)
 ========
 
 <Your answer here>
 
 Question 3(b)
 ========
 
 <Your answer here>
 
 Question 3(c)
 ========
 
 <Your answer here>
 
 Question 3(d)
 ========
 
 <Your answer here>
 
 Question 5: Reflection (Bonus Question)
 ==========================
 (a) How many hours did you spend on each problem of this problem set?
 
 <Your answer here>
 
 (b) In retrospect, what could you have done better to reduce the time you spent solving this problem set?
 
 <Your answer here>
 
 (c) What could the CS3217 teaching staff have done better to improve your learning experience in this problem set?
 
 <Your answer here>
 
 */
