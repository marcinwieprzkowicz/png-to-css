// Generated by CoffeeScript 1.4.0
(function() {
  var PngToCss,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty;

  PngToCss = (function() {
    var merge;

    PngToCss.prototype.defaults = {
      onReturn: function(result) {
        return console.log(result);
      },
      onError: function(error, type) {
        return console.log(error, type);
      }
    };

    function PngToCss(options) {
      var _this = this;
      this.options = merge({}, this.defaults, options);
      this.tCanvas = document.createElement('canvas');
      this.ctx = this.tCanvas.getContext('2d');
      this.tImg = new Image();
      this.tImg.onload = function() {
        _this.setImageData();
        return _this.generateBoxShadow();
      };
      this.tImg.onerror = function(event) {
        if (_this.options.onError != null) {
          return _this.options.onError.call(_this, event, 'load');
        }
      };
    }

    PngToCss.prototype.convert = function(imgPath) {
      this.ctx.clearRect(0, 0, this.tCanvas.width, this.tCanvas.height);
      if (/\.png$/i.test(imgPath)) {
        return this.tImg.src = imgPath;
      } else {
        if (this.options.onError != null) {
          return this.options.onError.call(this, {}, 'format');
        }
      }
    };

    PngToCss.prototype.setImageData = function() {
      this.ctx.drawImage(this.tImg, 0, 0);
      return this.imageData = this.ctx.getImageData(0, 0, this.tImg.width, this.tImg.height);
    };

    PngToCss.prototype.generateBoxShadow = function() {
      var col, halfHeight, halfWidth, opacity, result, row, shift;
      col = 0;
      row = 0;
      halfWidth = Math.round(this.tImg.width / 2);
      halfHeight = Math.round(this.tImg.height / 2);
      result = '';
      while (col < this.tImg.width && row < this.tImg.height) {
        shift = (row * this.tImg.width + col) * 4;
        opacity = parseFloat((this.imageData.data[shift + 3] / 255).toFixed(2));
        if (opacity !== 0) {
          if (col === halfWidth && row === halfHeight) {
            result += ",inset 0 0 0 1em " + (this.color(shift, opacity));
          } else {
            result += "," + (col - halfWidth) + "em " + (row - halfHeight) + "em " + (this.color(shift, opacity));
          }
        }
        col++;
        if (col === this.tImg.width) {
          row++;
          col = 0;
        }
      }
      if (this.options.onReturn != null) {
        return this.options.onReturn.call(this, result.substr(1));
      }
    };

    PngToCss.prototype.color = function(shift, opacity) {
      if (opacity === 1) {
        return this.rgbToHex(this.imageData.data[shift], this.imageData.data[shift + 1], this.imageData.data[shift + 2]);
      } else {
        return "rgba(" + this.imageData.data[shift] + "," + this.imageData.data[shift + 1] + "," + this.imageData.data[shift + 2] + "," + opacity + ")";
      }
    };

    PngToCss.prototype.componentToHex = function(component) {
      var hex;
      hex = component.toString(16);
      if (hex.length === 1) {
        return "0" + hex;
      } else {
        return hex;
      }
    };

    PngToCss.prototype.rgbToHex = function(r, g, b) {
      var rgb;
      rgb = "" + (this.componentToHex(r)) + (this.componentToHex(g)) + (this.componentToHex(b));
      if (rgb.substr(0, 3) === rgb.substr(3, 3)) {
        rgb = rgb.substr(0, 3);
      }
      return "#" + rgb;
    };

    merge = function() {
      var extension, extensions, property, target, _i, _len;
      target = arguments[0], extensions = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      for (_i = 0, _len = extensions.length; _i < _len; _i++) {
        extension = extensions[_i];
        for (property in extension) {
          if (!__hasProp.call(extension, property)) continue;
          target[property] = extension[property];
        }
      }
      return target;
    };

    return PngToCss;

  })();

  (typeof exports !== "undefined" && exports !== null ? exports : this).PngToCss = PngToCss;

}).call(this);
