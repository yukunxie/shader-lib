//
//  GLVertex.h
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
#import "GLColor.h"

@interface GLVertex : NSObject

@property GLVec3* point;
@property GLColor * color;

@end
