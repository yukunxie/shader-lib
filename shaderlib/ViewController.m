//
//  ViewController.m
//  simpleFBO
//
//  Created by Mahesh Venkitachalam on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"


// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};

GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};


GLfloat gTexCoordData[] =
{
    1.0f, 1.0f,
    0.0f, 1.0f,
    1.0f, 0.0f,
    0.0f, 0.0f
};


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!glContext) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = glContext;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == glContext) {
        [EAGLContext setCurrentContext:nil];
    }
    glContext = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:glContext];
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    
    _node = [[PPNode alloc] init: nil];
    _program = [[GLProgram alloc] init: @"FirstShader"];
    
    //[self loadShaders];
    
    //    glGenBuffers(1, &_texCoordBuffer);
    //    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    //    glBufferData(GL_ARRAY_BUFFER, sizeof(gTexCoordData), gTexCoordData, GL_STATIC_DRAW);
    //    // get text coord attribute index
    //    aTexCoordLoc = glGetAttribLocation(_program, "aTexCoord");
    //    glEnableVertexAttribArray(aTexCoordLoc);
    //    glVertexAttribPointer(aTexCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    //    // get sampler location
    //    uSamplerLoc = glGetUniformLocation(_program, "uSampler");
    //
    //    // initialize FBO
    //    [self setupFBO];
    //
    //    // to test texturing
    //    GLubyte tex[] = {255, 0, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 255, 0, 0, 255};
    //    glActiveTexture(GL_TEXTURE0);
    //    glGenTextures(1, &texId);
    //    glBindTexture(GL_TEXTURE_2D, texId);
    //    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    //    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    //    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    //    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    //    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE, tex);
    //    glBindTexture(GL_TEXTURE_2D, 0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:glContext];
    
    glDeleteBuffers(1, &_vertexBuffer);
    
    if (_glProgram) {
        glDeleteProgram(_glProgram);
        _glProgram = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 1000.0f);
    
    // Compute the model view matrix for the object rendered with ES2
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -200.0f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    
    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    GLKMatrix4 scale = GLKMatrix4MakeScale(1.5, 1.5, 1.5);
    
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // render FBO tex
    [self renderFBO];
    
    // reset to main framebuffer
    [((GLKView *) self.view) bindDrawable];
    
    //NSLog(@"%f, %f", [UIScreen mainScreen].scale, );
    float width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    float height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    
    glViewport(0, 0, width, height);
    // render main
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [_node bindGPUData];
    [_program linkProgram: &_modelViewProjectionMatrix];
    
    // bind to fbo texture
    //glBindTexture(GL_TEXTURE_2D, fboTex);
    
    // uncomment line below and comment out[self renderFBO]; above to test with normal texture
    // glBindTexture(GL_TEXTURE_2D, texId);
    
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    [_node renderNode];
    [_program unlinkProgram];
    
    //glDisable(GL_TEXTURE_2D);
}

#pragma mark - FBO

// intialize FBO
- (void)setupFBO
{
    fbo_width = 512;
    fbo_height = 512;
    
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &defaultFBO);
    
    glGenFramebuffers(1, &fboHandle);
    glGenTextures(1, &fboTex);
    glGenRenderbuffers(1, &depthBuffer);
    
    glBindFramebuffer(GL_FRAMEBUFFER, fboHandle);
    
    glBindTexture(GL_TEXTURE_2D, fboTex);
    glTexImage2D( GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 fbo_width, fbo_height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 NULL);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, fboTex, 0);
    
    glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA4, fbo_width, fbo_height);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuffer);
    
    // FBO status check
    GLenum status;
    status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    switch(status) {
        case GL_FRAMEBUFFER_COMPLETE:
            NSLog(@"fbo complete");
            break;
            
        case GL_FRAMEBUFFER_UNSUPPORTED:
            NSLog(@"fbo unsupported");
            break;
            
        default:
            /* programming error; will fail on all hardware */
            NSLog(@"Framebuffer Error");
            break;
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFBO);
}

// render FBO
- (void)renderFBO
{
    glBindTexture(GL_TEXTURE_2D, 0);
    glEnable(GL_TEXTURE_2D);
    glBindFramebuffer(GL_FRAMEBUFFER, fboHandle);
    
    glViewport(0,0, fbo_width, fbo_height);
    glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFBO);
}


#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
//    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _glProgram = _program.program;
    
//    // Create and compile vertex shader.
//    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"FirstShader" ofType:@"vs"];
//    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
//        NSLog(@"Failed to compile vertex shader");
//        return NO;
//    }
//    
//    // Create and compile fragment shader.
//    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"FirstShader" ofType:@"fs"];
//    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
//        NSLog(@"Failed to compile fragment shader");
//        return NO;
//    }
    
    // Attach vertex shader to program.
    glAttachShader(_glProgram, _program.shader.vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_glProgram, _program.shader.fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_glProgram, 0, "position");
    //glBindAttribLocation(_program, ATTRIB_NORMAL, "normal");
    glBindAttribLocation(_glProgram, 2, "color");
    
    // Link program.
    if (![self linkProgram:_glProgram]) {
        NSLog(@"Failed to link program: %d", _glProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_glProgram) {
            glDeleteProgram(_glProgram);
            _glProgram = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_glProgram, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_glProgram, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_glProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_glProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
