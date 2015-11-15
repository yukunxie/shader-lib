//
//  GLCamera.m
//  shaderlib
//
//  Created by 解玉坤 on 11/8/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import "GLCamera.h"


@implementation GLCamera
-(id)init{
    if (self == [super init])
    {
        _ViewFar    = 10000000.0;
        _ViewNear   = 1.0f;
        _FieldOfView= 60.0/ 180.0;
        
        [self initCamera];
    }
    return self;
}

-(void)initCamera{
    
}


@end
