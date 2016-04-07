//
//  HCUtilityMacro.h
//  BusinessArea
//
//  Created by 花晨 on 14-7-12.
//  Copyright (c) 2014年 花晨. All rights reserved.
//

#ifndef BusinessArea_HCUtilityMacro_h
#define BusinessArea_HCUtilityMacro_h

#if ! __has_feature(objc_arc)

#define CEAutorelease(__v) ([__v autorelease])
#define CEReturnAutoreleased CEAutorelease

#define CERetain(__v) ([__v retain])
#define CEReturnRetained CERetain

#define CERelease(__v) ([__v release])

#else
// -fobjc-arc
#define CEAutorelease(__v) do {} while (0)
#define CEReturnAutoreleased(__v) (__v)

#define CERetain(__v) do {} while (0)
#define CEReturnRetained(__v) (__v)

#define CERelease(__v) do {} while (0)

#endif

#ifdef DEBUG
#define DebugAssert(cnd, prompt)  NSAssert((cnd), (prompt))
#else
#define DebugAssert(cnd, prompt)
#endif


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif
