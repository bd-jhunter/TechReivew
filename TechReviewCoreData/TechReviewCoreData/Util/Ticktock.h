//
//  Ticktock.h
//  TechViewCodable
//
//  Created by jhunter on 2018/8/31.
//  Copyright © 2018 J.Hunter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ticktock : NSObject

@property (class, nonatomic, readonly) Ticktock *shared;

- (uint64_t)absluteTime;
- (uint64_t)convert:(uint64_t)begin end:(uint64_t)end;

@end
