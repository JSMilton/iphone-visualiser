#version 100

precision highp float;

uniform mat4 modelViewProjectionMatrix;
attribute vec4 position;

uniform float pointSize;

void main(){
    gl_Position = modelViewProjectionMatrix * position;
    gl_PointSize = pointSize;
}