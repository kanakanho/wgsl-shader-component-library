import type { Meta, StoryObj } from '@storybook/react-vite'
import expansionCircle from './shader/expansionCircle.wgsl?raw'
import hexagram from './shader/hexagram.wgsl?raw'
import WebGPU from './WebGPU'

const meta = {
  title: 'Shader',
  component: WebGPU,
  parameters: {
    layout: 'fullscreen',
    controls: { exclude: ['shaderSource'] },
  },
} satisfies Meta<typeof WebGPU>

export default meta

type Story = StoryObj<typeof meta>

export const Hexagram: Story = {
  args: {
    shaderSource: hexagram,
    bpm: 120,
    r: 0,
    g: 127,
    b: 255,
  },
}

export const ExpansionCircle: Story = {
  args: {
    shaderSource: expansionCircle,
    bpm: 120,
    r: 127,
    g: 127,
    b: 127,
  },
}
