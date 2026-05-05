struct Uniforms {
  time: f32,
  aspect_ratio: f32,
  screen_size: vec2<f32>,
  color: vec3<f32>,
};

@group(0) @binding(0) var<uniform> u: Uniforms;

struct VertexOutput {
  @builtin(position) position: vec4f,
  @location(0) uv: vec2f,
};

@vertex
fn vs_main(@builtin(vertex_index) VertexIndex : u32) -> VertexOutput {
  var pos = array<vec2f, 6>(
    vec2f(-1.0,  1.0), vec2f(-1.0, -1.0), vec2f( 1.0, -1.0),
    vec2f(-1.0,  1.0), vec2f( 1.0, -1.0), vec2f( 1.0,  1.0)
  );

  var output: VertexOutput;
  output.position = vec4f(pos[VertexIndex], 0.0, 1.0);
  output.uv = pos[VertexIndex];
  return output;
}

fn colorPalette(t: f32) -> vec3<f32> { 
  let a = vec3(0.5, 0.5, 0.5);
  let b = vec3(0.8, 0.1, 0.2);
  let c = vec3(1.0, 1.0, 1.0);
  let d = vec3(0.20, 0.00, 0.00);
  return a + b * cos(6.28318*(c*t+d)); 
}

@fragment
fn fs_main(input: VertexOutput) -> @location(0) vec4f {
    var uv = input.uv * vec2f(u.aspect_ratio, 1.0);
    var uv0 = uv;
    
    // アニメーション設定
    let t = u.time;
    let progress = fract(t);
    let zoom = pow(2.0, progress); // 2倍ズームのループ

    var finalColor = vec3(0.0);
    var mask = 1.0;

    // フラクタル・ループ
    for (var i: i32 = 0; i < 6; i++) {
        let index = f32(i);
        
        var d = length(uv0 - vec2f(0.0, -0.4) * index);
        d *= exp(-length(uv0));
        d = sin(d * 8.0 + u.time);
        d = abs(d);
        d = pow(0.08 / d, 1.2);
        
        let c = colorPalette(t * 0.8) * u.color;
        finalColor += c * d * mask * 0.4;
    }

        // フラクタル・ループ
    for (var i: i32 = 0; i < 4; i++) {
        // uv0 = fract(uv * 1.5) - 0.5;
        let index = f32(i);
        
        var d = length(uv0 - vec2f(0.0, 0.6) * index);
        d *= exp(-length(uv0));
        d = sin(d * 8.0 + u.time);
        d = abs(d);
        d = pow(0.08 / d, 1.2);
        
        let c = colorPalette(-1 * t * 0.8) * u.color;
        finalColor += c * d * mask * 0.4;
    }

            // フラクタル・ループ
    for (var i: i32 = 0; i < 2; i++) {
        // uv0 = fract(uv * 1.5) - 0.5;
        let index = f32(i);
        
        var d = length(uv0 - vec2f(0.8, 0.0) * index);
        d *= exp(-length(uv0));
        d = sin(d * 8.0 + u.time);
        d = abs(d);
        d = pow(0.08 / d, 1.2);
        
        let c = colorPalette(1 * t * 0.6) * u.color;
        finalColor += c * d * mask * 0.4;
    }

                // フラクタル・ループ
    for (var i: i32 = 0; i < 2; i++) {
        // uv0 = fract(uv * 1.5) - 0.5;
        let index = f32(i);
        
        var d = length(uv0 - vec2f(-0.8, 0.0) * index);
        d *= exp(-length(uv0));
        d = sin(d * 8.0 + u.time);
        d = abs(d);
        d = pow(0.08 / d, 1.2);
        
        let c = colorPalette(-1 * t * 0.4) * u.color;
        finalColor += c * d * mask * 0.4;
    }

    return vec4f(finalColor, 1.0);
}