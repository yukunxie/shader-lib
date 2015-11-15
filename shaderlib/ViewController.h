//
//  ViewController.h
//  shaderlib
//
//  Created by 解玉坤 on 11/8/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>
#import "PPNode.h"
#import "GLProgram.h"

@interface ViewController : GLKViewController{
    
    PPNode *_node;
    GLProgram * _program;
    
    GLuint _glProgram;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    GLuint _colorArray;
    GLuint _colorBuffer;
    
    GLuint _texCoordBuffer;
    
    int uSamplerLoc;
    int aTexCoordLoc;
    
    // FBO variables
    GLuint fboHandle;
    GLuint depthBuffer;
    GLuint fboTex;
    int fbo_width;
    int fbo_height;
    
    // test
    GLuint texId;
    
    // GL context
    EAGLContext *glContext;
    
    GLint defaultFBO;
}

//@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;
- (void)setupFBO;


- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

@end

