
local Sprites = {}

Sprites.loading = {
  source = "img/btn/loading.png",
  frames = {width=48, height=48, numFrames=8},
  sequences = {
      { name = "stop", loopCount = 1, start = 1, count=1},
      { name = "play", time=1000, start = 1, count=8}
  }
}

Sprites.share = {
  source = "img/btn/sprShare.png",
  frames = {width=170, height=170, numFrames=5},
  sequences = {
      { name = "stop", loopCount = 1, start = 1, count=1},
      { name = "play", time=600, frames={1,1,1,1,1,2,3,4,5,6}, loopCount = 1}
  }
}

Sprites.down = {
  source = "img/btn/sprDown.png",
  frames = {width=170, height=170, numFrames=5},
  sequences = {
      { name = "stop", loopCount = 1, start = 1, count=1},
      { name = "play", time=600, frames={1,1,1,1,1,2,3,4,5,6}, loopCount = 1}
  }
}

Sprites.check = {
  source = "img/btn/sprCheck.png",
  frames = {width=204, height=204, numFrames=5},
  sequences = {
      { name = "stop", loopCount = 1, start = 1, count=1},
      { name = "play", time=800, frames={1,1,1,2,3,4,5}, loopCount = 1}
  }
}

Sprites.promo = {
  source = "img/btn/sprPromo.png",
  frames = {width=170, height=131, numFrames=5},
	sequences = {
      { name = "stop", loopCount = 1, start = 1, count=1},
      { name = "play", time=600, frames={1,1,1,1,1,2,3,4,5,6}, loopCount = 1}
  }
}

return Sprites