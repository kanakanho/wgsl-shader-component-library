import type { Meta, StoryObj } from '@storybook/react-vite'
import base from './shader/base.wgsl?raw'
import chromaticAberration from './shader/chromaticAberration.wgsl?raw'
import expansionCircle from './shader/expansionCircle.wgsl?raw'
import frostedGlass from './shader/frostedGlass.wgsl?raw'
import hexagram from './shader/hexagram.wgsl?raw'
import mosaic from './shader/mosaic.wgsl?raw'
import nyan from './shader/nyan.wgsl?raw'
import ring from './shader/ring.wgsl?raw'
import spiral from './shader/spiral.wgsl?raw'
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

export const Base: Story = {
  args: {
    shaderSource: base,
    bpm: 120,
    r: 127,
    g: 127,
    b: 127,
  },
}

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

export const Nyan: Story = {
  args: {
    shaderSource: nyan,
    bpm: 120,
    r: 255,
    g: 127,
    b: 0,
  },
}

export const FrostedGlass: Story = {
  args: {
    shaderSource: frostedGlass,
    bpm: 120,
    r: 127,
    g: 255,
    b: 127,
  },
}

export const Mosaic: Story = {
  args: {
    shaderSource: mosaic,
    bpm: 120,
    r: 127,
    g: 127,
    b: 127,
  },
}

export const Spiral: Story = {
  args: {
    shaderSource: spiral,
    bpm: 120,
    r: 127,
    g: 127,
    b: 127,
  },
}

export const ChromaticAberration: Story = {
  args: {
    shaderSource: chromaticAberration,
    bpm: 120,
    r: 127,
    g: 127,
    b: 127,
  },
}

export const Ring: Story = {
  args: {
    shaderSource: ring,
    bpm: 120,
    r: 127,
    g: 127,
    b: 127,
  },
}
