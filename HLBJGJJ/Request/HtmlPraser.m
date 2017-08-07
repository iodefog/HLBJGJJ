//
//  HtmlPraser.m
//  HLBJGJJ
//
//  Created by Hongli li on 16/1/31.
//  Copyright © 2017年 honglili. All rights reserved.
//

#import "HtmlPraser.h"
#import <IGHTMLQuery.h>
#import "NSString+Regular.h"

@implementation HtmlPraser

-(NSArray<StatusBean *> *)praserGlobalInfoList:(NSString *)html{
    NSString * path = @"/html/body/table[2]/tr[3]/td/table/tr/td/div/table/tr/td/div/div[2]/table/tr/td";
    
    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet* contents = [document queryWithXPath: path];
    NSMutableArray * values = [NSMutableArray array];
    
    for (IGXMLNode * node in contents) {
        [values addObject:[node text]];
    }

    NSString *url = nil;
    NSArray *array = [html componentsSeparatedByString:@"javascript:window.open('gjj_cxls.jsp?"];
    
    if (array .count >1) {
        array = [array[1] componentsSeparatedByString:@";"];
    }
    
    if (array.count >0) {
        url = [NSString stringWithFormat:@"http://www.bjgjj.gov.cn/wsyw/wscx/gjj_cxls.jsp?%@",array[0]];
    }
    
    if (url) {
        [values addObject:url];
    }
    
    return values;
}
//*[@id="new-mytable"]/tbody/tr[2]/td[2]/div

-(NSArray<StatusBean *> *)praserStatusList:(NSString *)html{
    NSString * path = @"/html/body/table[2]/tr[3]/td/table/tr/td/div/table/tr[2]/td/div/table/tr[position()>=2]";

    IGHTMLDocument *document = [[IGHTMLDocument alloc]initWithHTMLString:html error:nil];
    IGXMLNodeSet* contents = [document queryWithXPath: path];
    
    NSMutableArray<StatusBean*> * status = [NSMutableArray array];
    
    for (IGXMLNode * node in contents) {
        
        StatusBean * bean = [[StatusBean alloc] init];
        IGXMLNodeSet * set = [node children];
        
        NSString * signedId = [set[0] text];
        NSString * companyName = [set[1] text];
        NSString * allText = [set[1] html];
        NSString * baseUrl = @"http://www.bjgjj.gov.cn/wsyw/wscx/";
        NSString * companyLink = [baseUrl stringByAppendingString:[allText stringWithRegular:@"gjj_cx.jsp(.*)lx=0"]];
        NSString * statusInCompany = [set[2] text];
        
        bean.signedId = signedId;
        bean.companyName = companyName;
        bean.companyLink = companyLink;
        bean.status = statusInCompany;
        
        NSLog(@"~~~~~~~~~ %@  %@   %@   %@", signedId, companyName, companyLink, status);
        
        [status insertObject:bean atIndex:0];
        
    }
    return status;
}
@end
