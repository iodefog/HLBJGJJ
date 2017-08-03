//
//  NSString+Converter.h
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/30.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Converter)

+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary;

+ (NSString *)toHexhexaDecimalWithBinarySystem:(NSString *)binary;

-(NSString *)replaceUnicode;
@end
