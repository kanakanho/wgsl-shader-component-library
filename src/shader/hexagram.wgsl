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

// 六角形への距離を計算する関数
fn sdHexagon(p: vec2f, r: f32) -> f32 {
    let k = vec3f(-0.866025404, 0.5, 0.577350269); // cos(30), sin(30), tan(30)
    var p_abs = abs(p);
    p_abs -= 2.0 * min(dot(k.xy, p_abs), 0.0) * k.xy;
    p_abs -= vec2f(clamp(p_abs.x, -k.z * r, k.z * r), r);
    return length(p_abs) * sign(p_abs.y);
}
// フラグメントシェーダー
@fragment
fn fs_main(
  input: VertexOutput
) -> @location(0) vec4f {
  var uv = input.uv * vec2f(u.aspect_ratio, 1.0);

  var uv0 = uv;
  var finalColor = vec3(0.0);

  let bh = 0.5;
  let r = vec2f(1.0, sqrt(3.0));
  let h = r * bh;

  let a = (fract(uv / r) - bh) * r;
  let b = (fract((uv - h) / r) - bh) * r;
  
  var gv: vec2f;
  if (length(a) < length(b)) {
      gv = a;
  } else {
      gv = b;
  }

  var d = sdHexagon(gv, bh * 0.87);

  let line_width = 0.06;
  var edge = 1.0 - smoothstep(0.01, line_width, abs(d));

  var col = colorPalette(length(uv0) + u.time * 0.5);
  col *= u.color;
  
  edge = sin(edge * 8.0 + u.time);
  edge = abs(d);
  edge = pow(0.04 / edge, 1.2);

  finalColor += edge * col;

  return vec4f(finalColor, 1.0);
}
