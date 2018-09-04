//
//  Ticktock.m
//  TechViewCodable
//
//  Created by jhunter on 2018/8/31.
//  Copyright © 2018 J.Hunter. All rights reserved.
//

#import "Ticktock.h"
#import <mach/mach_time.h>

@interface Ticktock ()
@property (nonatomic, assign) mach_timebase_info_data_t clock_timebase;
@end

@implementation Ticktock

+ (Ticktock *)shared {
    static Ticktock *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Ticktock alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    mach_timebase_info(&_clock_timebase);
    return self;
}
    
- (uint64_t)absluteTime {
    uint64_t machTime = mach_absolute_time();
    return machTime;
}

- (uint64_t)convert:(uint64_t)begin end:(uint64_t)end {
    uint64_t machTime = end - begin;
    uint64_t nanos = (machTime * _clock_timebase.numer) / _clock_timebase.denom;
    return nanos / 1000000;
}

@end
