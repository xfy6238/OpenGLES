
attribute vec4 position;
attribute vec4 color;

uniform float elapsedTime;
//投影矩阵 观察坐标 -> 剪裁坐标
uniform mat4 projectionMatrix;
//观察矩阵  世界坐标 -> 观察坐标
uniform mat4 cameraMatrix;
//模型矩阵  从局部坐标 -> 世界坐标
uniform mat4 modelMatrix;

varying vec4 fragColor;

void main(void) {
    fragColor = color;
    
    //顶点依次通过 模型矩阵 观察矩阵 投影矩阵
    mat4 mvp = projectionMatrix * cameraMatrix * modelMatrix;
    gl_Position = mvp * position;
}
