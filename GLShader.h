//
//  ShaderKit.h
//  shaderlib
//
//  Created by 解玉坤 on 11/8/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface GLShader : NSObject{
    GLuint _vertexShader;
    GLuint _fragmentShader;
}

@property GLuint vertShader;
@property GLuint fragShader;


-(id) initWithString: (NSString*) vsContext : (NSString*) fsContext;
-(void) dumpShaderStatusInfo: (GLuint) shader;

+(id) createShaderWithString: (NSString*) vsContext : (NSString*)fsContext;
+(id) createShaderWithFile: (NSString*) vsFilename : (NSString*)fsFilename;

@end
