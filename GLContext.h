//
//  Context.h
//  shaderlib
//
//  Created by 解玉坤 on 11/8/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

#import "GLProgram.h"

@interface GLContext : NSObject

@property(strong, nonatomic) EAGLContext *context;

-(id)init: (GLKView *) view ;
-(void)render: (GLProgram*) program: (GLuint)vertexArray : (GLuint)vertexBuffer;

-(void)clearScreenWithColor;

@end
