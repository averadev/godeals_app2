
local Sprites = {}

Sprites.loading = {
  source = "img/btn/loading.png",
  frames = {width=48, height=48, numFrames=8},
  sequences = {
      { name = "stop", loopCount = 1, start = 1, count=1},
      { name = "play", time=1000, start = 1, count=8}
  }
}

return Sprites