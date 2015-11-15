//
//  GLMatrix.h
//  shaderlib
//
//  Created by 解玉坤 on 11/11/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

#import "GLVector.h"

@interface GLMatrix4 : NSObject{
    GLfloat * _matrix;
}

-(id)init: (GLfloat[16]) array;
@property GLfloat * matrix;

+(id)createLookAt: (GLVec3*) eyePosition :(GLVec3*) targetPosition:  (GLVec3*) up;

@end
