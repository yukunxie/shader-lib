//
//  GLMatrix.m
//  shaderlib
//
//  Created by 解玉坤 on 11/11/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import "GLMatrix.h"

@implementation GLMatrix4

-(id)init: (GLfloat[16]) array{
    if (self == [super init]){
        memcpy(_matrix, array, 16 * sizeof(GLfloat));
    }
    return self;
}

@synthesize matrix = _matrix;

+(id)createLookAt: (GLVec3*) eyePosition :(GLVec3*) targetPosition:  (GLVec3*) up{
    GLfloat data[16] = {};
    
    return [[GLMatrix4 alloc] init: data];
}

@end
