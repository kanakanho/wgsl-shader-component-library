import shaderSource from './shader/default.wgsl?raw'
import WebGPU from './WebGPU'

function App() {
  return (
    <WebGPU bpm={120} r={1} g={1} b={1} shaderSource={shaderSource} />
  )
}

export default App
