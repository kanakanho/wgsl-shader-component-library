import { useEffect, useRef } from 'react'
import WebGPURender from './WebGPURender'

export interface WebGPUFragment {
  bpm: number
  r: number
  g: number
  b: number
}

interface WebGPUProps extends WebGPUFragment {
  shaderSource: string
}

export default function WebGPU({ bpm, r, g, b, shaderSource }: WebGPUProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null)

  const fragValue: WebGPUFragment = {
    bpm,
    r,
    g,
    b,
  }

  useEffect(() => {
    let isDisposed = false
    let stopRender: (() => void) | null = null

    const initWebGPU = async () => {
      if (!canvasRef.current)
        return

      // webgpuコンテキストの取得
      const context = canvasRef.current.getContext('webgpu') as GPUCanvasContext

      // deviceの取得
      const g_adapter = await navigator.gpu.requestAdapter()
      if (!g_adapter) {
        console.error('WebGPU is not supported on this browser.')
        return
      }
      const g_device = await g_adapter.requestDevice()
      if (isDisposed)
        return

      const presentationFormat = navigator.gpu.getPreferredCanvasFormat()
      context.configure({
        device: g_device,
        format: presentationFormat,
        alphaMode: 'opaque', // or 'premultiplied'
      })

      stopRender = WebGPURender(
        canvasRef.current,
        g_device,
        context,
        presentationFormat,
        4,
        shaderSource,
        fragValue,
      )
    }

    initWebGPU()
    return () => {
      isDisposed = true
      if (stopRender)
        stopRender()
    }
  }, [bpm, r, g, b])
  return (
    <canvas
      ref={canvasRef}
      width={window.innerWidth}
      height={window.innerHeight}
    >
    </canvas>
  )
}
