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
  let d = vec3(0.50, 0.20, 0.10);
  return a + b * cos(6.28318*(c*t+d)); 
}


// フラグメントシェーダー
@fragment
fn fs_main(
  input: VertexOutput
) -> @location(0) vec4f {
  var uv = input.uv * vec2f(u.aspect_ratio, 1.0);

  return vec4f(colorPalette(length(uv) + u.time * 0.5) * u.color, 1.0);
}
