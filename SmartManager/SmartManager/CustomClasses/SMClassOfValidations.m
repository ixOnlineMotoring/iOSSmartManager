//
//  SMClassOfValidations.m
//  Smart Manager
//
//  Created by Liji Stephen on 13/08/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMClassOfValidations.h"

@implementation SMClassOfValidations
/*

For example, you have a phone number like this: 3022513240 in string format and you want to convert it to a form like this: (302)-251-3240

The code for this in Objective-C:

NSMutableString *stringts = [NSMutableString stringWithString:self.ts.text];
[stringts insertString:@"(" atIndex:0];
[stringts insertString:@")" atIndex:4];
[stringts insertString:@"-" atIndex:5];
[stringts insertString:@"-" atIndex:9];
self.ts.text = stringts;
This basically creates a MutableString and inserts the parentheses at index 0 and 4 and inserts the hyphens at index 5 and 9.

The code for this in Swift:

var stringts: NSMutableString = self.ts.text
stringts.insertString("(", atIndex: 0)
stringts.insertString(")", atIndex: 4)
stringts.insertString("-", atIndex: 5)
stringts.insertString("-", atIndex: 9)
self.ts.text = stringts

*/

@end
