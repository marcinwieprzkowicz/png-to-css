###

Library that convert png images to css (box-shadow)

@version  1.1
@author Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

####


class PngToCss

  defaults:
    onReturn: (result) ->
      console.log result
    onError: (error, type) ->
      console.log error, type


  constructor: (options) ->
    @options = merge {}, @defaults, options

    @tCanvas = document.createElement 'canvas'
    @ctx = @tCanvas.getContext '2d'

    @tImg = new Image() # temporary image
    @tImg.onload = =>
      @setImageData()
      @generateBoxShadow()

    @tImg.onerror = (event) =>
      @options.onError.call this, event, 'load' if @options.onError?


  convert: (imgPath) ->
    @ctx.clearRect 0, 0, @tCanvas.width, @tCanvas.height

    if /\.png$/i.test imgPath
      @tImg.src = imgPath
    else
      @options.onError.call this, {}, 'format' if @options.onError?


  setImageData: ->
    @ctx.drawImage @tImg, 0, 0
    @imageData = @ctx.getImageData 0, 0, @tImg.width, @tImg.height


  generateBoxShadow: ->
    col = 0
    row = 0
    halfWidth = Math.round @tImg.width / 2
    halfHeight = Math.round @tImg.height / 2
    result = ''

    while col < @tImg.width && row < @tImg.height
      shift = (row * @tImg.width + col) * 4
      opacity = parseFloat (@imageData.data[shift + 3] / 255).toFixed(2)

      unless opacity == 0
        if col == halfWidth && row == halfHeight
          result += ",inset 0 0 0 1em #{@color shift, opacity}"
        else
          result += ",#{col - halfWidth}em #{row - halfHeight}em #{@color shift, opacity}"
      col++

      if col == @tImg.width
        row++
        col = 0

    @options.onReturn.call this, result.substr(1) if @options.onReturn?


  color: (shift, opacity) ->
    if opacity == 1
      @rgbToHex @imageData.data[shift], @imageData.data[shift + 1], @imageData.data[shift + 2]
    else
      "rgba(#{@imageData.data[shift]},#{@imageData.data[shift + 1]},#{@imageData.data[shift + 2]},#{opacity})"


  componentToHex: (component) ->
    hex = component.toString 16
    if hex.length == 1 then "0#{hex}" else hex


  rgbToHex: (r, g, b) ->
    rgb = "#{@componentToHex r}#{@componentToHex g}#{@componentToHex b}"
    rgb = rgb.substr(0, 3) if rgb.substr(0, 3) == rgb.substr(3, 3)
    "##{rgb}"


  merge = (target, extensions...) ->
    for extension in extensions
      for own property of extension
        target[property] = extension[property]
    target


(exports ? this).PngToCss = PngToCss
