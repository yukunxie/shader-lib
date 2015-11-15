//
//  GLProgram.h
//  shaderlib
//
//  Created by 解玉坤 on 11/8/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>
#import "GLShader.h"

@interface GLProgram : NSObject{
    GLuint _program;
    GLuint _glProjectionMatrix;
    GLuint _glModelViewMatrix;
    GLShader* _shader;
    GLKTextureInfo *_spriteTexture;
    bool _isLinked;
}

@property GLuint program;
@property (strong, nonatomic)GLShader* shader;

+(id)createProgram;

-(id)init: (NSString*)shaderName;
-(void)linkProgram: (GLKMatrix4*) mvpMatrix;
-(void)unlinkProgram;
-(void)dumpProgramStatusInfo;


@end
