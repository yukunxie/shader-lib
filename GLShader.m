//
//  ShaderKit.m
//  shaderlib
//
//  Created by 解玉坤 on 11/8/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import "GLShader.h"

@implementation GLShader


@synthesize vertShader = _vertexShader;
@synthesize fragShader = _fragmentShader;

-(id) initWithString: (NSString*) vsContext : (NSString*) fsContext
{
    if (self == [super init])
    {
        self.vertShader = [self compileShader : GL_VERTEX_SHADER : vsContext];
        self.fragShader = [self compileShader : GL_FRAGMENT_SHADER : fsContext];
    }
    return self;
}

+(id) createShaderWithString: (NSString*) vsContext : (NSString*)fsContext
{
    
    GLShader * shader = [[GLShader alloc] initWithString : vsContext : fsContext];
    return shader;
}

+(id) createShaderWithFile: (NSString*) vsFilename : (NSString*)fsFilename
{
    NSString* vsContext = [NSString stringWithContentsOfFile:vsFilename encoding:NSUTF8StringEncoding error:nil];
    NSString* fsContext = [NSString stringWithContentsOfFile:fsFilename encoding:NSUTF8StringEncoding error:nil];

    GLShader * shader = [[GLShader alloc] initWithString : vsContext : fsContext];
    return shader;
}

-(void) dumpShaderStatusInfo: (GLuint) shader{
    GLsizei	infoLen = 0;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
    if (infoLen > 0)
    {
        GLchar *infoLog = (GLchar *)malloc(infoLen);
        glGetShaderInfoLog(shader, infoLen, &infoLen, infoLog);
        NSLog(@"dump shader infos:\n%s\n", infoLog);
        free(infoLog);
    }
}

- (GLuint)compileShader:(GLenum)type :(NSString *)context
{
    GLint status;
    const GLchar *source = (GLchar *)[context UTF8String];
    if (!source) {
        NSLog(@"Failed to load shader[%d]", type);
        return -1;
    }
    
    GLuint shader = glCreateShader(type);
    if (shader == 0){
        NSLog(@"create shader fail type[%d]", type);
        [self dumpShaderStatusInfo: shader];
        return shader;
    }
    
    NSLog(@"shader %d, %d", shader, type);
    glShaderSource(shader, 1, &source, NULL);
    glCompileShader(shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        NSLog(@"dsfsdfjskdfksdjfkj");
        glDeleteShader(shader);
        return -1;
    }
    
    return shader;
}

@end
