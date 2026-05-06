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

fn sdHexagon(p: vec2f, r: f32) -> f32 {
    let k = vec3f(-0.866025404, 0.5, 0.577350269); // cos(30), sin(30), tan(30)
    var p_abs = abs(p);
    p_abs -= 2.0 * min(dot(k.xy, p_abs), 0.0) * k.xy;
    p_abs -= vec2f(clamp(p_abs.x, -k.z * r, k.z * r), r);
    return length(p_abs) * sign(p_abs.y);
}

fn rand(p: vec2f) -> f32 {
  return fract(sin(dot(p, vec2f(12.9898, 78.233))) * 43758.5453);
}

fn basePattern(uv: vec2f) -> vec3<f32> {
  var originalUV = uv;
  var uv0 = uv;
  var finalColor = vec3(0.0);

  for (var i:i32 = 0; i < 8; i++) {
    originalUV = fract(originalUV * 1.5) - 0.5;

    var d = length(originalUV) * exp(-length(uv0));

    let index = f32(i);
    var col = colorPalette(length(uv0) + index * 0.4 + u.time * 0.4);
    
    d = sin(d * 8.0 + u.time);
    d = abs(d);
    d = pow(0.08 / d, 1.4);

    finalColor += col * d;
  }
  return finalColor;
}

fn spiralEffect(uv: vec2f) -> vec3<f32> {
  let screen = u.screen_size;
  let center = screen * 0.5;
  let radius = max(screen.x, screen.y);
  let strength = 4.0;

  let uv01 = uv * 0.5 + 0.5;
  let pos = uv01 * screen - center;
  let len = length(pos);

  if (len >= radius) {
    return basePattern(uv * vec2f(u.aspect_ratio, 1.0));
  }

  let uzu = clamp(1.0 - (len / radius), 0.0, 1.0) * strength;
  let x = pos.x * cos(uzu) - pos.y * sin(uzu);
  let y = pos.x * sin(uzu) + pos.y * cos(uzu);
  let retPos = (vec2f(x, y) + center) / screen;
  let uvWarp = (retPos * 2.0 - 1.0) * vec2f(u.aspect_ratio, 1.0);

  return basePattern(uvWarp);
}

// フラグメントシェーダー
@fragment
fn fs_main(
  input: VertexOutput
) -> @location(0) vec4f {
  var uv = input.uv * vec2f(u.aspect_ratio, 1.0);

  let glassColor = spiralEffect(uv) * u.color;
  return vec4f(glassColor, 1.0);
}
