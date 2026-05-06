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
  // フルスクリーン・クアッド（2つの三角形）の頂点データ
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
  let b = vec3(0.5, 0.5, 0.5);
  let c = vec3(1.0, 1.0, 1.0);
  let d = vec3(0.00, 0.10, 0.20);
  return a + b * cos(6.28318*(c*t+d)); 
}

// フラグメントシェーダー
// output: vec4f - RGBAカラーを表す4次元ベクトル
@fragment
fn fs_main(
  input: VertexOutput
) -> @location(0) vec4f {
  // UV座標を取得
  // 正規化されたスクリーン座標を計算
  var uv = input.uv * vec2f(u.aspect_ratio, 1.0);

  var uv0 = uv;
  var finalColor = vec3(0.0);

  // var rotation = u.time * 0.5;
  // let s = sin(rotation);
  // let c = cos(rotation);
  // uv = mat2x2f(c, -s, s, c) * uv;

  // var scale = sin(u.time * 0.3) * 0.6 + 1.2;
  // uv = uv * scale;

  for (var i:i32 = 0; i < 8; i++) {
    uv = fract(uv * 1.5) - 0.5;

    var d = length(uv) * exp(-length(uv0));

    let index = f32(i);
    var col = colorPalette(length(uv0) + index * 0.4 + u.time * 0.4);
    
    d = sin(d * 8.0 + u.time);
    d = abs(d);
    d = pow(0.08 / d, 1.4);

    finalColor += col * d;
  }

  return vec4f(finalColor * u.color, 1.0);
}