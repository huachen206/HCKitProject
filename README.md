# HCDB#
=========


###使用CocoaPods安装###

`pod 'HCKitProject/HCDB', '~> 0.4.0'`

###结构###
  - `HCDAO`
  - `HCDBTable`
  - `HCDBModel`
  - `HCDBHelper`
  - `HCDBManager`
  - `HCDBTableField`
  - `HCVersionTable`
  - `NSObject+HCDBExtend`
      
      
========
##用法
以前做项目的时候，使用sql的时候很不方便，特别是在创建、改动表的时候，而且数据模型与表的关联很弱，同样改动时很麻烦。于是花了好几个月，几次推翻重来，完善了这个工具，并在项目中被很好的使用。

如果有更好的建议或者发现bug，欢迎联系我  *huachen206@163.com*

主要是功能在于自动创建，修改表。而且增删改查都很方便。

示例代码可以查看工程中的HCDBDemo。
使用时如下：


```
    CarModel *car;
    NSArray *carList = [[DAO dao].carTable selectAll];
    if (carList.count) {
        car = carList.firstObject;
        car.wheelNumber ++;
        [[DAO dao].carTable replaceWithModel:car];
    }else{
        car = [CarModel defaultCar];
        [[DAO dao].carTable insertWithModel:car];
    }

    [[DAO dao].carTable deleteWithModel:car];

```

要达到使用的程度，需要至少创建三个类。其中DBModel与DBTable是一一对应的。DAO则可以管理多个DBTable。

###1.创建模型


先以HCDBModel为父类创建一个数据模型，其中有4个用于修饰属性的宏：

 - `HC_PRIMARY_KEY`  （设置主键）
 - `HC_AUTOINCREMENT` （自增）
 - `HC_PRIMARY_KEY_AUTOINCREMENT` （设置主键且自增）
 - `HC_IGNORE` （忽略）
 
 
 自定义的对象是不支持的，不过不用担心，不支持的类型在运行时会有assert提示。
 
```
@interface VehicleModel : HCDBModel
@property (nonatomic,assign) NSUInteger HC_PRIMARY_KEY_AUTOINCREMENT(vid);
@property (nonatomic,strong) NSString *scientificName;
@property (nonatomic,strong) NSString *manufacturer;
@property(nonatomic,strong) NSData *attachData;

@property (nonatomic,assign,getter=isFantasy) BOOL fantasy;
@property (nonatomic,assign) float weight;
@property (nonatomic,assign) long maxSpeed;
@property (nonatomic,assign) double displacement;

@property (nonatomic,assign) id HC_IGNORE(driver);
@property (nonatomic,strong) NSObject *HC_IGNORE(forIgnoreExample);

-(BOOL)isFantasy;
@end

@interface CarModel : VehicleModel
@property (nonatomic,assign) int wheelNumber;
@end

@interface PlaneModel : VehicleModel
@property (nonatomic,assign) int wingNumber;
@property (nonatomic,assign) float maxHeight;
@end

```

默认只会关联本身定义属性，如果需要关联父类定义的属性，怎需要重载`depth`方法

```
@implementation CarModel
+(NSInteger)depth{
    return 2;
}
@end
@implementation PlaneModel
+(NSInteger)depth{
    return 2;
}
@end
```

###2.创建关联表

创建模型的关联表，以`HCDBTable`为父类

```
@interface Table_carModel : HCDBTable

@end
@interface Table_planeModel : HCDBTable

@end
```
表中关联模型，并根据需要自定义筛选数据的条件。只需把sql语句写入就可以了。

```
@implementation Table_carModel
-(Class)tableModelClass{
    return [CarModel class];
}

-(NSArray *)selectWithWheelNumber:(int)wheelNumber{
    __block NSArray *models = nil;
    [self.fmDbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE deviceId = %@",self.tableName,@(wheelNumber)]];
        models = [self modelListWithFMResultSet:rs];
    }];
    return models;
}

@end
@implementation Table_planeModel
-(Class)tableModelClass{
    return [PlaneModel class];
}

@end

```

###3.创建DAO

创建数据库操作入口，并关联表,以`HCDAO`为父类。

一个DAO管理多个表，且存在同一个SQL文件下，重载`baseDBHelper`方法，可指定路径。

通常一个项目，只需要一个DAO，并且使用默认路径就可以了。



```
#import "HCDAO.h"
#import "Table_carModel.h"
#import "Table_planeModel.h"
@interface DAO : HCDAO
@property (nonatomic,strong) Table_carModel *carTable;
@property (nonatomic,strong) Table_planeModel *planeTable;

@end

#import "DAO.h"

@implementation DAO
@synthesize baseDBHelper = _baseDBHelper;

-(HCDBHelper *)baseDBHelper{
    NSString *dbFileName = @"VehicleDBFile";
    NSString *dbPath =[HCDBHelper dbPathWithFileName:dbFileName];
    _baseDBHelper =[[HCDBManager shared] dbHelperWithDbPath:dbPath];
    if (!_baseDBHelper) {
        _baseDBHelper = [[HCDBHelper alloc] initWithDbFileName:dbFileName];
        [[HCDBManager shared] addDBHelper:_baseDBHelper];
    }
    return _baseDBHelper;
}

@end

```

##4.扩展功能

表结构更新后，进行数据迁移。通过复制-新建-插入数据-删除旧表 的方法支持删除字段，但还是建议尽量不要删除字段。


```
#import "Table_carModel.h"
@implementation Table_carModel
-(Class)tableModelClass{
    return [CarModel class];
}

-(NSInteger)tableVersion{
    //默认为1，每次表结构变动且需要数据迁移时，将此值+1；
    return 3;
}

-(BOOL)tableMigrationWithCurrentTableVersion:(NSInteger)currentVersion{
    //此调用在表结构升级之前，version会逐级上升。建议尽量不要删除字段
    if (currentVersion == 2) {
        //do something 比如将数据全部取出
    }else if (currentVersion ==3){
        
        
    }
    return YES;
}

-(BOOL)autoUpgradeTable{
    BOOL success =[super autoUpgradeTable];
    if (success) {
        //此时表已升级为最新，与当前DBModel相匹配。
    }
    return success;
}
@end

```



## License

AFNetworking is released under the MIT license. See LICENSE for details.

