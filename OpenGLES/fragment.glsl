/*
 最简单的fragment Shader 什么也没有处理
varying lowp vec4 fragColor;

void main(void) {
    gl_FragColor = fragColor;
}
*/

//Fragment 中的变量只能用uniform和varying进行修饰
//varying 表示是从vertex Shader传过来的值
//变量声明精度
varying lowp vec4 fragColor;
uniform highp float elapsedTime;

void main(void) {
    highp float processedElapsedTime = elapsedTime;
    highp float intensity = (sin(processedElapsedTime) + 1.0) / 2.0;
    gl_FragColor = fragColor * intensity;
}
