// fragment shader

#version 100

precision highp float;
uniform sampler2D tex;
uniform vec3 color;

void main()
{
    float alpha = texture2D(tex, gl_PointCoord).r * 0.6;
    gl_FragColor = vec4(color.x, color.y, color.z, alpha);
}