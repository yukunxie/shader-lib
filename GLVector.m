//
//  GLPoint.m
//  shaderlib
//
//  Created by 解玉坤 on 11/8/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import "GLVector.h"

@implementation GLVec2

-(id)init: (float) x :(float) y {
    if (self == [super init]){
        self.x = x;
        self.y = y;
    }
    return self;
}

-(void)normalize{
    GLfloat length = sqrtf(powf(self.x, 2.0) + powf(self.y, 2.0));
    self.x /= length;
    self.y /= length;
}
@end


@implementation GLVec3

-(id)init: (float) x :(float) y :(float)z {
    if (self == [super init: x : y]){
        self.z = z;
    }
    return self;
}

-(void)normalize{
    GLfloat length = sqrtf(powf(self.x, 2.0) + powf(self.y, 2.0) + powf(self.z, 2.0));
    self.x /= length;
    self.y /= length;
    self.z /= length;
}

-(void) subtract: (GLVec3*) vec{
    self.x -= vec.x;
    self.y -= vec.y;
    self.z -= vec.z;
}

-(id) cross:(GLVec3*) vec
{
    GLfloat x = (self.y * vec.z) - (self.z * vec.y);
    GLfloat y = (self.z * vec.x) - (self.x * vec.z);
    GLfloat z = (self.x * vec.y) - (self.y * vec.x);
    
    return [[GLVec3 alloc] init: x : y : z ];
}

@end

@implementation GLVec4

-(id)init: (float) x :(float) y :(float)z :(float)w {
    if (self == [super init: x : y : z]){
        self.w = w;
    }
    return self;
}

-(void)normalize{
    GLfloat length = sqrtf(powf(self.x, 2.0) + powf(self.y, 2.0) + powf(self.z, 2.0) + powf(self.z, 2.0));
    self.x /= length;
    self.y /= length;
    self.z /= length;
    self.w /= length;
}

@end

@implementation GLRect: NSObject

-(id)init: (float) x :(float) y :(float)w :(float)h
{
    if (self == [super init]){
        self.x = x;
        self.y = y;
        self.width = w;
        self.height = h;
    }
    return self;
}

@end

@implementation GLSize: NSObject

-(id)init:(float)w :(float)h{
    if (self == [super init]){
        self.width = w;
        self.height = h;
    }
    return self;
}

@end
