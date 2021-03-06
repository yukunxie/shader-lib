//
//  Shader.fsh
//  simpleFBO
//
//  Created by Mahesh Venkitachalam on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

uniform sampler2D uSampler;
//
varying highp vec2 vTexCoord;
//
varying highp vec4 colorVarying;

void main()
{
    //lowp vec4 texCol = texture2D(uSampler, vTexCoord);
    
    //gl_FragColor = vec4(texCol.rgb, 1.0);
    //gl_FragColor = colorVarying;
    
    //gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
    gl_FragColor = colorVarying * texture2D(uSampler, vTexCoord.xy);
}
