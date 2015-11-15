//
//  GLCamera.h
//  shaderlib
//
//  Created by 解玉坤 on 11/8/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>
#import <math.h>


@interface GLCamera : NSObject{
    GLfloat _ViewFar;
    GLfloat _ViewNear;
    GLfloat _FieldOfView;
}

-(void)initCamera;

@end
