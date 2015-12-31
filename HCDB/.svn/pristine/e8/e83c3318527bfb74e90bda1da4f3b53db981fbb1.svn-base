//
//  SQLHelper.m
//  WrapperSQL
//
//  Created by 花晨 on 14-7-18.
//  Copyright (c) 2014年 花晨. All rights reserved.
//

#import "SQLHelper.h"
@interface SQLHelper()
@property (nonatomic,strong) NSMutableArray *elements;

@end


@implementation SQLHelper
+(SQLHelper *)CreatWithTableName:(NSString *)tableName{
    return [[[self class] alloc] initWithTableName:tableName];
}
-(id)initWithTableName:(NSString *)tableName{
    if (self = [super init]) {
        self.tableName = tableName;
        self.elements =[[NSMutableArray alloc] init];
        self.types = [[NSMutableArray alloc] init];
        self.fields = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addType:(NSString *)Type field:(NSString *)field{
    [self.types addObject:Type];
    [self.fields addObject:field];
    
    NSString *tmpStr = [NSString stringWithFormat:@"%@ %@",field,Type];
    [self.elements addObject:tmpStr];
}


-(NSString *)holeElementString{
    NSString *holeElementString = @"";
    for (NSString *elStr in self.elements) {
        if (holeElementString.length == 0) {
            holeElementString = elStr;
        }else{
            holeElementString = [[holeElementString stringByAppendingString:@","] stringByAppendingString:elStr];
        }
    }
    return holeElementString;
}

-(NSString *)creatString{
    NSString *creatTable = @"CREATE TABLE IF NOT EXISTS %@ ()";
    creatTable =[NSString stringWithFormat:creatTable,self.tableName];
    
    return [creatTable stringByReplacingOccurrencesOfString:@"()" withString:[NSString stringWithFormat:@"(%@)",[self holeElementString]]];
}

-(NSString *)dropTableString{
    return [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", self.tableName];

}


@end
