/*
attribute vec4 position;
attribute vec4 color;

varying vec4 fragColor;

 //这是最简单的着色器 , 什么也没有处理
void main(void) {
    fragColor = color;
    gl_Position = position;
}
*/

attribute vec4 position;
attribute vec4 color;

uniform float elapsedTime;
varying vec4 fragColor;

void main(void) {
    fragColor = color;
    //elapsedTime 表示程序运行经过时间的秒数
    float angle = elapsedTime * 1.0;
    float xPos = position.x * cos(angle) - position.y * sin(angle);
    float yPos = position.x * sin(angle) + position.y * cos(angle);
    gl_Position = vec4(xPos,yPos, position.z, 1.0);
}
