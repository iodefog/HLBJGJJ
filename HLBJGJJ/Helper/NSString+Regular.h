//
//  NSString+Regular.h
//  CCF
//
//  Created by honglili on 17/8/3.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Regular)

-(NSString*) stringWithRegular:(NSString *) regular;

-(NSString*) stringWithRegular:(NSString *) regular andChild:(NSString *) childRegular;

-(NSString*) trim;

@end
