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

fn circle(surfacePosition: vec2f, pos: vec2f, size: f32, color: vec3f) -> vec3f {
	return color * size / distance(pos,surfacePosition);
}

fn basePattern(uv: vec2f) -> vec3<f32> {
  let t = u.time * 0.08;
  var theta = 11.0;
  let r = 0.6;
  var pos = vec2f(0.0);
  var finalColor = vec3f(0.0);

  const PI: f32 = 3.14159265359; 
  const N = 60;
  for(var i: i32 = 0; i < N; i++) {
    let size = f32(i) * 0.005;
    theta += PI / (f32(N)*0.5);
    pos = vec2f(cos(theta*t)*r, sin(theta-t)*r);
    var c = vec3f(0.0);
    c.r = 0.1 * cos(t*f32(i));
    c.g = 0.1 * sin(t*f32(i));
    c.b = 0.09 * sin(f32(i));
    finalColor += circle(uv, pos, size, c);
  }
  return finalColor;
}

// フラグメントシェーダー
@fragment
fn fs_main(
  input: VertexOutput
) -> @location(0) vec4f {
  var uv = input.uv * vec2f(u.aspect_ratio, 1.0);
  return vec4f(basePattern(uv * vec2f(u.aspect_ratio, 1.0)) * u.color, 1.0);
}
