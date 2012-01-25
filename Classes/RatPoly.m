#import "RatPoly.h"


@implementation RatPoly

@synthesize terms;

// Note that since there is no variable called "degree" in our class,the compiler won't synthesize 
// the "getter" for "degree". and we have to write our own getter
-(int)degree{ // 5 points
    // EFFECTS: returns the degree of this RatPoly object. 
    
	if (self.terms.count == 0)
        return 0;
    else {
        return ((RatTerm*) [self.terms objectAtIndex: 0]).expt;
    }
}

// Check that the representation invariant is satisfied
-(void)checkRep{ // 5 points
    if (terms == nil)
        [NSException raise: @"RatPoly invariant violated" format: @"Nil terms array"];
    
	int i;
    int prevExpt;
    for (i = 0; i < terms.count; i++) {
        RatTerm *t = [terms objectAtIndex: i];
        /*
        if (t == nil)
            [NSException raise: @"RatPoly invariant violated" format: @"Nil term at index %d", i]; */
        if ([t.coeff isEqual: [RatNum initZERO]])
            [NSException raise: @"RatPoly invariant violated" format: @"Zero term"];
        if (t.expt < 0)
            [NSException raise: @"RatPoly invariant violated" format: @"Negative exponent: %d", t.expt];
        if (i > 0 && prevExpt <= t.expt)
            [NSException raise: @"RatPoly invariant violated" format: @"Non-descending exponent order"];
        
        prevExpt = t.expt;
    }
}

-(id)init { // 5 points
    //EFFECTS: constructs a polynomial with zero terms, which is effectively the zero polynomial
    //           remember to call checkRep to check for representation invariant
    terms = [NSArray array];
    [self checkRep];
    return self;
}

-(id)initWithTerm:(RatTerm*)rt{ // 5 points
    //  REQUIRES: [rt expt] >= 0
    //  EFFECTS: constructs a new polynomial equal to rt. if rt's coefficient is zero, constructs
    //             a zero polynomial remember to call checkRep to check for representation invariant
    
    if ([rt.coeff isEqual:[RatNum initZERO]]) {
        terms = [NSArray array];
    } else {
        terms = [NSArray arrayWithObject:rt];
    }
    
    [self checkRep];
    return self;
}

-(id)initWithTerms:(NSArray*)ts{ // 5 points
    // REQUIRES: "ts" satisfies clauses given in the representation invariant
    // EFFECTS: constructs a new polynomial using "ts" as part of the representation.
    //            the method does not make a copy of "ts". remember to call checkRep to check for representation invariant
    
    terms = ts;
    [self checkRep];
    return self;
}

-(RatTerm*)getTerm:(int)deg { // 5 points
    // REQUIRES: self != nil && ![self isNaN]
    // EFFECTS: returns the term associated with degree "deg". If no such term exists, return
    //            the zero RatTerm
    for (RatTerm *t in self.terms) {
        if (t.expt == deg) {
            return t;
        } else if (t.expt < deg) {
            break;
        }
    }
    return [RatTerm initZERO];
}

-(BOOL)isNaN { // 5 points
    // REQUIRES: self != nil
    //  EFFECTS: returns YES if this RatPoly is NaN
    //             i.e. returns YES if and only if some coefficient = "NaN".
    for (RatTerm *t in self.terms) {
        if ([t.coeff isNaN])
            return YES;
    }
    return NO;
}


-(RatPoly*)negate { // 5 points
    // REQUIRES: self != nil 
    // EFFECTS: returns the additive inverse of this RatPoly.
    //            returns a RatPoly equal to "0 - self"; if [self isNaN], returns
    //            some r such that [r isNaN]
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (RatTerm *t in self.terms) {
        [arr addObject: [t negate]];
    }
    return [[RatPoly alloc] initWithTerms: [NSArray arrayWithArray:arr]];
}


// Addition operation
-(RatPoly*)add:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self+p; if [self isNaN] or [p isNaN], returns
    //            some r such that [r isNaN]
    
    NSMutableArray *result = [NSMutableArray array];
    int i, j;
    for (i = 0, j = 0; i < self.terms.count && j < p.terms.count; ) {
        RatTerm *u = [self.terms objectAtIndex:i];
        RatTerm *v = [p.terms objectAtIndex:j];
        if (u.expt != v.expt) {
            if (u.expt > v.expt) {
                [result addObject: u];
                i++;
            } else {
                [result addObject: v];
                j++;
            }
        } else {
            RatTerm *sum = [u add:v];
            if (![sum isEqual:[RatTerm initZERO]])
                [result addObject: sum];
            i++; j++;
        }
    }
    
    while (i < self.terms.count) {
        [result addObject:[self.terms objectAtIndex:i]];
        i++;
    }
    
    while (j < p.terms.count) {
        [result addObject: [p.terms objectAtIndex:j]];
        j++;
    }
    
    return [[RatPoly alloc] initWithTerms:[NSArray arrayWithArray: result]];
}

// Subtraction operation
-(RatPoly*)sub:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self-p; if [self isNaN] or [p isNaN], returns
    //            some r such that [r isNaN]
    
    return [self add: [p negate]];
}


// Multiplication operation
-(RatPoly*)mul:(RatPoly*)p { // 5 points
    // REQUIRES: p!=nil, self != nil
    // EFFECTS: returns a RatPoly r, such that r=self*p; if [self isNaN] or [p isNaN], returns
    // some r such that [r isNaN]
    RatPoly *result = [[RatPoly alloc] init];
    for (RatTerm *u in self.terms) {
        NSMutableArray *a = [NSMutableArray array];
        for (RatTerm *v in p.terms) {
            [a addObject:[u mul:v]];
        }
        result = [result add: [[RatPoly alloc] initWithTerms: [NSArray arrayWithArray: a]]];
    }
    
    return result;
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
    if (p.terms.count == 0 || [self isNaN] || [p isNaN]) 
        return [[RatPoly alloc] initWithTerm: [RatTerm initNaN]];
    
    RatPoly *rem = self;
    NSMutableArray *quotient = [NSMutableArray array];
    while ([rem degree] >= [p degree]) {
        RatTerm *q = [(RatTerm*) [rem.terms objectAtIndex: 0] div: [p.terms objectAtIndex: 0]];
        [quotient addObject: q];
        rem = [rem sub: [p mul: [[RatPoly alloc] initWithTerm: q]]];
    }
    return [[RatPoly alloc] initWithTerms: [NSArray arrayWithArray:quotient]];
}

-(double)eval:(double)d { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns the value of this RatPoly, evaluated at d
    //            for example, "x+2" evaluated at 3 is 5, and "x^2-x" evaluated at 3 is 6.
    //            if [self isNaN], return NaN
    
    if ([self isNaN])
        return NAN;
    else {
        double value = 0.0;
        for (RatTerm *t in self.terms) 
            value += [t eval:d];
        return value;
    }
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
    
    if ([self isNaN])
        return @"NaN";
    else if (self.terms.count == 0)
            return @"0";
    else {
        NSMutableString *str = [NSMutableString string];
        
        int i;
        for (i = 0; i < self.terms.count; i++) {
            RatTerm *t = [self.terms objectAtIndex:i];
            if (i == 0) {
                [str appendString: [t stringValue]];
            } else {
                if ([t.coeff isPositive]) {
                    [str appendFormat: @"+%@", [t stringValue]];
                } else {
                    [str appendString: [t stringValue]];
                }
            }
        }
        
        return [NSString stringWithString: str];
    }
}


// Builds a new RatPoly, given a descriptive String.
+(RatPoly*)valueOf:(NSString*)str { // 5 points
    // REQUIRES : 'str' is an instance of a string with no spaces that
    //              expresses a poly in the form defined in the stringValue method.
    //              Valid inputs include "0", "x-10", and "x^3-2*x^2+5/3*x+3", and "NaN".
    // EFFECTS : return a RatPoly p such that [p stringValue] = str
    if ([str isEqual: @"NaN"] || [str isEqual: @"-NaN"]) {
        return [[RatPoly alloc] initWithTerm:[RatTerm initNaN]];
    } else if ([str isEqual:@"0"]) {
        return [[RatPoly alloc] init];
    } else {
        NSString *norm = [str stringByReplacingOccurrencesOfString:@"-" 
                                                        withString:@"+-"
                                                           options:NSLiteralSearch
                                                             range:NSMakeRange(0, str.length)];
        
        norm = [norm stringByReplacingOccurrencesOfString:@"-NaN" 
                                              withString:@"NaN"
                                                 options:NSLiteralSearch
                                                   range:NSMakeRange(0, str.length)];
        
        NSArray *tokens = [norm componentsSeparatedByString: @"+"];
        
        NSMutableArray *a = [NSMutableArray array];
        for (NSString *str in tokens) {
            if (![str isEqual:@""])
                [a addObject: [RatTerm valueOf: str]];
        }
        
        return [[RatPoly alloc] initWithTerms: [NSArray arrayWithArray: a]];
    }
}

// Equality test
-(BOOL)isEqual:(id)obj { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns YES if and only if "obj" is an instance of a RatPoly, which represents
    //            the same rational polynomial as self. All NaN polynomials are considered equal
    if ([obj isKindOfClass: [RatPoly class]]) {
        RatPoly *o = (RatPoly*) obj;
        if ([self isNaN] && [obj isNaN])
            return YES;
        
        if ([self.terms isEqualToArray:o.terms])
            return YES;
    }
            
    return NO;
}

@end

/* 
 
 Question 1(a)
 ========
 
 Let us define the negation operation: r = -p
 set r = empty polynomial
 foreach term tp in p:
    insert term tr, which is the negation of the term tp,
        into r
 
 The subtraction operation: r = p - q can then be defined:
 set t = -q by applying negation operation
 set r = p + t by applying addition operation
 
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
 if v is zero polynomial or u is NaN polynomial or v is NaN polynomial
    set q = NaN polynomial and return
 
 set q = zero polynomial
 set m to refer to u
 while degree of m is larger than or equal to degree of v
    let tm be the term with the largest exponent in m
    let tv be the term with the largest exponent in v
    insert new term tq, whose coefficient is the quotient of 
        the coefficients of tm and tv and exponent is the difference
        between the exponents of tm and tv, into q
    set d = tq * v
    set m = m - d
 
 
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
 
 To minimize the amount of changes to comply with the new requirement, we only
 modify the functions so that it works with all the inputs under the new
 requirement. There is no need to remove the code to simplify the rational 
 number.
 
 List of methods that need to be changed:
    checkRep: remove the whole clause: if (denom > 0) { ... }
    (compareTo:
        These 2 lines may result in overflow, even in the original version.
        long a = self.numer * otherRatNum.denom;
        long b = otherRatNum.numer * self.denom;)
 // TODO: Incomplete
 
 Question 2(d)
 ========
 
 It is sufficient to call checkRep only at the end of the constructors because
 RatNum is an immutable class. The rep of RatNum is only modified at constructor.
 A RatNum object is created when we need to record the new value of an operation,
 and the constructor will be called in this case. Therefore, we only need to check
 whether the object is created correctly at the constructor.
 
 Question 3(a)
 ========
 
 In the case of RatTerm class, only at the end of the constructors. The RatTerm class
 is immutable, so the constructors are the only places the value of the rep can be
 modified. (Operations will create new RatTerm object whenever new values need to
 be recorded, and the operations will call the constructor to create new objects).
 
 Question 3(b)
 ========
 
 If the class is already implemented, we can enforce the old invariants on the exit
 to reduce the amount of modifications (as long as there is no conflict).
 
 List of methods that need to be changed:
 
 
 Question 3(c)
 ========
 
 <Your answer here>
 
 Question 3(d)
 ========
 
 Only the second one.
 
 If coefficient is 0, which means the term is 0, it is safe to set the exponent to 0
 to make the implementation of other functions easier.
 
 The first one is no good, since it will not allow constant to be a term. // TODO: Check this again!
 
 Question 5: Reflection (Bonus Question)
 ==========================
 (a) How many hours did you spend on each problem of this problem set?
 
 <Your answer here>
 
 (b) In retrospect, what could you have done better to reduce the time you spent solving this problem set?
 
 <Your answer here>
 
 (c) What could the CS3217 teaching staff have done better to improve your learning experience in this problem set?
 
 This mode of learning is good. I can learn a lot of things myself at my own speed. The examples provided are
 good reference when learning a new language.
 
 However, there are some points I would like to comment on:
 - Please clean up the comments from the last year to avoid confusion.
 - Please list out the changes that have been made to the source code. It is very annoying every time the source code 
 is reuploaded to the workbin, but we don't know about the changes in the code.
 
 */
