#import "RatTerm.h"


@implementation RatTerm

@synthesize coeff;
@synthesize expt;

// Checks that the representation invariant holds.
-(void) checkRep{
    if (coeff == nil) {
        [NSException raise:@"ratterm representation error" format:@"coefficient is nil"];
    }
    if ([coeff isEqual:[RatNum initZERO]] && expt != 0) {
        [NSException raise:@"ratterm representation error" format:@"coeff is zero but expt is not"];
    }
}

-(id)initWithCoeff:(RatNum*)c Exp:(int)e{
    // REQUIRES: (c, e) is a valid RatTerm
    // EFFECTS: returns a RatTerm with coefficient c and exponent e
    
    RatNum *ZERO = [RatNum initZERO];
    // if coefficient is 0, exponent must also be 0
    // we'd like to keep the coefficient, so we must retain it
    
    if ([c isEqual:ZERO]) {
        coeff = ZERO;
        expt = 0;
    } else {
        coeff = c;
        expt = e;
    }
    [self checkRep];
    return self;
}

+(id)initZERO { // 5 points
    // EFFECTS: returns a zero ratterm
    return [[RatTerm alloc] initWithCoeff:[RatNum initZERO] Exp:0];
}

+(id)initNaN { // 5 points
    // EFFECTS: returns a nan ratterm
    return [[RatTerm alloc] initWithCoeff:[RatNum initNaN] Exp:0];
}

-(BOOL)isNaN { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: return YES if and only if coeff is NaN
    return [coeff isNaN];
}

-(BOOL)isZero { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: return YES if and only if coeff is zero
    return [coeff isEqual:[RatNum initZERO]];
}


// Returns the value of this RatTerm, evaluated at d.
-(double)eval:(double)d { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: return the value of this polynomial when evaluated at
    //            'd'. For example, "3*x^2" evaluated at 2 is 12. if 
    //            [self isNaN] returns YES, return NaN
    
    if (self.isNaN) {
        return NAN;
    } else {
        if (self.expt == 0)
            return [self.coeff doubleValue];
        else {
            return pow(d, self.expt) * [self.coeff doubleValue];
        }
    }
}

-(RatTerm*)negate{ // 5 points
    // REQUIRES: self != nil 
    // EFFECTS: return the negated term, return NaN if the term is NaN
    if (self.isNaN) {
        return self;
    } else {
        return [[RatTerm alloc] initWithCoeff:[self.coeff negate] Exp: self.expt];
    }
}



// Addition operation.
-(RatTerm*)add:(RatTerm*)arg { // 5 points
    // REQUIRES: (arg != null) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
    //            arg.isZero() || self.isNaN() || arg.isNaN())).
    // EFFECTS: returns a RatTerm equals to (self + arg). If either argument is NaN, then returns NaN.
    //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.
    
    if ([self isNaN] || [arg isNaN]) {
        return [RatTerm initNaN];
    } else if (self.expt != arg.expt) {
        if ([self isZero]) {
            return arg;
        } else if ([arg isZero]) {
            return self;
        } else {
            @throw [NSException exceptionWithName: @"RatTerm add error" 
                                           reason: @"Cannot add two valid terms with different exponent"
                                         userInfo: nil];
        }
    } else {
        return [[RatTerm alloc] initWithCoeff:[self.coeff add:arg.coeff] Exp:self.expt];
    }
}


// Subtraction operation.
-(RatTerm*)sub:(RatTerm*)arg { // 5 points
    // REQUIRES: (arg != nil) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
    //             arg.isZero() || self.isNaN() || arg.isNaN())).
    // EFFECTS: returns a RatTerm equals to (self - arg). If either argument is NaN, then returns NaN.
    //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.
    
    return [self add:[arg negate]];
}


// Multiplication operation
-(RatTerm*)mul:(RatTerm*)arg { // 5 points
    // REQUIRES: arg != null, self != nil
    // EFFECTS: return a RatTerm equals to (self*arg). If either argument is NaN, then return NaN
    
    return [[RatTerm alloc] initWithCoeff:[self.coeff mul: arg.coeff] Exp: self.expt + arg.expt];
}


// Division operation
-(RatTerm*)div:(RatTerm*)arg { // 5 points
    // REQUIRES: arg != null, self != nil
    // EFFECTS: return a RatTerm equals to (self/arg). If either argument is NaN, then return NaN
    
    return [[RatTerm alloc] initWithCoeff:[self.coeff div:arg.coeff] Exp: self.expt - arg.expt];
}


// Returns a string representation of this RatTerm.
-(NSString*)stringValue { // 5 points
    //  REQUIRES: self != nil
    // EFFECTS: return A String representation of the expression represented by this.
    //           There is no whitespace in the returned string.
    //           If the term is itself zero, the returned string will just be "0".
    //           If this.isNaN(), then the returned string will be just "NaN"
    //		    
    //          The string for a non-zero, non-NaN RatTerm is in the form "C*x^E" where C
    //          is a valid string representation of a RatNum (see {@link ps1.RatNum}'s
    //          toString method) and E is an integer. UNLESS: (1) the exponent E is zero,
    //          in which case T takes the form "C" (2) the exponent E is one, in which
    //          case T takes the form "C*x" (3) the coefficient C is one, in which case T
    //          takes the form "x^E" or "x" (if E is one) or "1" (if E is zero).
    // 
    //          Valid example outputs include "3/2*x^2", "-1/2", "0", and "NaN".
    
    if ([self isNaN]) {
        return @"NaN";
    } else if (self.expt == 0) {
        return [self.coeff stringValue];
    } else if (self.expt == 1) {
        if ([self.coeff isEqual:[[RatNum alloc] initWithInteger:1]])
            return @"x";
        else if ([self.coeff isEqual:[[RatNum alloc] initWithInteger:-1]])
            return @"-x";
        else 
            return [NSString stringWithFormat:@"%@*x", [self.coeff stringValue]];
    } else {
        if ([self.coeff isEqual:[[RatNum alloc] initWithInteger:1]])
            return [NSString stringWithFormat:@"x^%d", self.expt];
        else if ([self.coeff isEqual:[[RatNum alloc] initWithInteger:-1]])
            return [NSString stringWithFormat:@"-x^%d", self.expt];
        else 
            return [NSString stringWithFormat:@"%@*x^%d", [self.coeff stringValue], self.expt];
    }
}

+(RatNum*) parseCoeff:(NSString*)str {
    if ([str isEqual:@""]) {
        return [[RatNum alloc] initWithInteger:1];
    } else if ([str isEqual:@"-"]) {
        return [[RatNum alloc] initWithInteger:-1];
    } else {
        return [RatNum valueOf: [str substringToIndex: str.length - 1]];
    }
}

+(int) parseExpt:(NSString*) str {
    if ([str isEqual:@""]) {
        return 1;
    } else {
        return [[str substringFromIndex:1] intValue];
    }
}

// Build a new RatTerm, given a descriptive string.
+(RatTerm*)valueOf:(NSString*)str { // 5 points
    // REQUIRES: that self != nil and "str" is an instance of
    //             NSString with no spaces that expresses
    //             RatTerm in the form defined in the stringValue method.
    //             Valid inputs include "0", "x", "-5/3*x^3", and "NaN"
    // EFFECTS: returns a RatTerm t such that [t stringValue] = str
    
    if ([str isEqual:@"NaN"])
        return [RatTerm initNaN];
    else {
        if ([str rangeOfString:@"x" options:NSLiteralSearch range:NSMakeRange(0, str.length)].location != NSNotFound) {
            NSArray *tokens = [str componentsSeparatedByString:@"x"];
            RatNum *c = [RatTerm parseCoeff: [tokens objectAtIndex: 0]];
            int e = [RatTerm parseExpt: [tokens objectAtIndex: 1]];
            return [[RatTerm alloc] initWithCoeff:c Exp:e];
        } else {
            return [[RatTerm alloc] initWithCoeff:[RatNum valueOf: str] Exp: 0];
        }
    }
}

//  Equality test,
-(BOOL)isEqual:(id)obj { // 5 points
    // REQUIRES: self != nil
    // EFFECTS: returns YES if "obj" is an instance of RatTerm, which represents
    //            the same RatTerm as self.
    
    if ([obj isKindOfClass:[RatTerm class]]) {
        RatTerm *term = (RatTerm*) obj;
        if ([self isNaN] && [obj isNaN])
            return YES;
        return [self.coeff isEqual:term.coeff] && self.expt == term.expt;
    }
    
    return NO;
}

@end
