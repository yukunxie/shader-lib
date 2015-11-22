//
//  Shader.vsh
//  simpleFBO
//
//  Created by Mahesh Venkitachalam on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;
//attribute vec3 normal;
attribute vec2 aTexCoord;
//
varying highp vec2 vTexCoord;
//
varying highp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    //    vec3 eyeNormal = normalize(normalMatrix * normal);
    //    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    //    vec4 diffuseColor = vec4(0.4, 0.4, 1.0, 1.0);
    
    //   float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    
    //  colorVarying = diffuseColor * nDotVP;
    
    gl_Position = modelViewProjectionMatrix * position;
    colorVarying = color;
    
    // pass to fragment shader
    vTexCoord = aTexCoord;
}
