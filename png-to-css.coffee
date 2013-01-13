# 
# Library that convert png images to css (box-shadow)
# 
# @version  1.0
# @author Marcin Wieprzkowicz (wiemar@o2.pl)
#

extend = (obj, extensions...) ->
  (obj[key] = value) for key, value of ext for ext in extensions
  obj

class PngToCss
  
  options:
    onReturn: (result) ->
      console.log result
    onError: (error, type) ->
      console.log error, type
  
  constructor: (options) ->
    extend @options, options
    
    @tCanvas = document.createElement 'canvas'
    @ctx = @tCanvas.getContext '2d'
    
    @tImg = new Image()
    @tImg.onload = =>
      @setImageData()
      @generateBoxShadow()
    @tImg.onerror = (e) =>
      @options.onError.call this, e, 'load' if @options.onError?
  
  convert: (imgPath) ->
    @ctx.clearRect 0, 0, @tCanvas.width, @tCanvas.height
    
    if /\.png$/i.test(imgPath)
      @tImg.src = imgPath
    else
      @options.onError.call this, {}, 'format' if @options.onError?
  
  setImageData: ->
    @ctx.drawImage @tImg, 0, 0
    @imageData = @ctx.getImageData 0, 0, @tImg.width, @tImg.height
  
  generateBoxShadow: ->
    col = 0
    row = 0
    halfWidth = Math.round(@tImg.width / 2)
    halfHeight = Math.round(@tImg.height / 2)
    result = ''
    
    while col < @tImg.width and row < @tImg.height
      shift = ((row * @tImg.width) + col) * 4
      opacity = parseFloat((@imageData.data[shift + 3] / 255).toFixed(2))
      unless opacity is 0
        if col is halfWidth and row is halfHeight
          result += ',inset 0 0 0 1em ' + @color(shift, opacity)
        else
          result += ',' + (col - halfWidth) + 'em ' + (row - halfHeight) + 'em ' + @color(shift, opacity)
      col++
      
      if col is @tImg.width
        row++
        col = 0
    @options.onReturn.call this, result.substr(1) if @options.onReturn?
  
  color: (shift, opacity) ->
    if opacity is 1
      @rgbToHex @imageData.data[shift], @imageData.data[shift + 1], @imageData.data[shift + 2]
    else
      'rgba(' + @imageData.data[shift] + ',' + @imageData.data[shift + 1] + ',' + @imageData.data[shift + 2] + ',' + opacity + ')'
  
  componentToHex: (c) ->
    hex = c.toString(16);
    if hex.length is 1 then "0" + hex else hex
  
  rgbToHex: (r, g, b) ->
    rgb = @componentToHex(r) + @componentToHex(g) + @componentToHex(b)
    rgb = rgb.substr(0, 3) if rgb[0] is rgb[1] and rgb[1] is rgb[2] and rgb.substr(0, 3) is rgb.substr(3, 3)
    '#' + rgb
  
(exports ? this).PngToCss = PngToCss
