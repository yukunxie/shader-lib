//
//  ObjLoaderAssist.m
//  shaderlib
//
//  Created by 解玉坤 on 11/22/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import "ObjLoaderAssist.h"

@implementation NSVertex
-(id) init{
    self = [super init];
    return self;
}
@end

@implementation Vec2
-(id) init: (float)x: (float)y{
    if (self = [super init]){
        self.x = x;
        self.y = y;
    }
    return self;
}
@end

@implementation Vec3
-(id) init: (float)x: (float)y: (float) z{
    if (self = [super init: x: y]){
        self.z = z;
    }
    return self;
}
@end

@implementation NSVector3Idx

-(id) init:(int) x: (int)y: (int)z
{
    if (self = [super init])
    {
        _data[0] = x;
        _data[1] = y;
        _data[2] = z;
    }
    return self;
}

-(int *) data{
    return _data;
}

@end

@implementation NSTriangleIdx

-(id) init:(NSVector3Idx* ) pos: (NSVector3Idx* ) tuv: (NSVector3Idx* ) nrm{
    if (self = [super init]){
        self.pos = pos;
        self.tuv = tuv;
        self.nrm = nrm;
        self.useNrm = YES;
        self.useUV = YES;
    }
    return self;
}
@end