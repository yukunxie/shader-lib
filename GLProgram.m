//
//  GLProgram.m
//  shaderlib
//
//  Created by 解玉坤 on 11/8/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import "GLProgram.h"
#import "GLShader.h"

@implementation GLProgram

@synthesize program = _program;
@synthesize shader  = _shader;

+(id)createProgram{
    GLProgram * program = [[GLProgram alloc] init];
    return program;
}

-(id)init: (NSString*)shaderName
{
    if (self == [super init]){
        self.program = glCreateProgram();
        NSString* vertShaderPathname = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"vs"];
        NSString* fragShaderPathname = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"fs"];
        self.shader = [GLShader createShaderWithFile: vertShaderPathname: fragShaderPathname];
        _isLinked = NO;
        
        GLKTextureInfo *spriteTexture;
        NSError *theError;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TestImage" ofType:@"png"]; // 1
        
        _spriteTexture = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:&theError];
    }
    return self;
}

-(void)dumpProgramStatusInfo{
    GLint infoLenght;
    glGetProgramiv(self.program, GL_INFO_LOG_LENGTH, &infoLenght);
    if (infoLenght == 0) {
        return ;
    }
    
    GLchar *info = (GLchar *)malloc(infoLenght);
    glGetProgramInfoLog(self.program, infoLenght, &infoLenght, info);
    NSLog(@"Program link info:\n%s\n", info);
    free(info);
}

-(void)linkProgram: (GLKMatrix4*) mvpMatrix{
    if (_isLinked){
        return ;
    }
    
    // Attach vertex shader to program.
    glAttachShader(self.program, self.shader.vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(self.program, self.shader.fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(self.program, GLKVertexAttribPosition, "position");
    //glBindAttribLocation(_program, ATTRIB_NORMAL, "normal");
    glBindAttribLocation(self.program, GLKVertexAttribColor, "color");
    
    glBindAttribLocation(self.program, GLKVertexAttribTexCoord0, "aTexCoord");
    
    GLint status;
    glLinkProgram(self.program);
    
#if defined(DEBUG)
    [self dumpProgramStatusInfo];
#endif
    
    glGetProgramiv(self.program, GL_LINK_STATUS, &status);
    assert(status != 0);
    
    glUseProgram(self.program);
    
    // Get uniform locations.
    GLuint _glMVP = glGetUniformLocation(self.program, "modelViewProjectionMatrix");
    glUniformMatrix4fv(_glMVP, 1, 0, mvpMatrix->m);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(_spriteTexture.target, _spriteTexture.name); // 3
    glEnable(_spriteTexture.target);
    
    GLuint _textureUniform = glGetUniformLocation(self.program, "uSampler");
    glUniform1i(_textureUniform, 0);
    
    _isLinked = YES;
}

-(void)unlinkProgram {
    if (!_isLinked){
        return ;
    }
    _isLinked = NO;
    glDetachShader(self.program, self.shader.vertShader);
    glDetachShader(self.program, self.shader.fragShader);
}

@end
