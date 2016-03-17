//
//  HCTestDBModel.h
//  HCKitProject
//
//  Created by 花晨 on 15/12/11.
//  Copyright © 2015年 花晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCDBModel.h"


@interface HCTestDBModel : HCDBModel

@property(nonatomic,assign) NSInteger HC_PRIMARY_KEY_AUTOINCREMENT(index);
@property(nonatomic,strong) NSString* HC_VARCHAR_20(astring);
@property(nonatomic,assign) BOOL abool;
@property(nonatomic,assign) id aid;
@property(nonatomic,assign) char achar;
@property(nonatomic,assign) int aint;
@property(nonatomic,assign) short ashort;
@property(nonatomic,assign) long along;
@property(nonatomic,assign) unsigned char auchar;
@property(nonatomic,assign) unsigned int auint;
@property(nonatomic,assign) unsigned short aushort;
@property(nonatomic,assign) unsigned long aulong;
@property(nonatomic,assign) float afloat;
@property(nonatomic,assign) double adouble;
@property(nonatomic,assign) void *avoid;
@property(nonatomic,assign) char *axchar;
@property(nonatomic,assign) Class aclass;
@property(nonatomic,assign) SEL asel;
@property(nonatomic,assign) Point apoint;
@property(nonatomic,strong) NSArray *aarray;
@property(nonatomic,strong) NSDictionary *adic;
@property(nonatomic,strong) HCDBModel *ahelp;



@end
