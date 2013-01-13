#PNG to CSS
Convert png images to css (box-shadow)

## Demo
See **[demo](http://marcinwieprzkowicz.github.com/png-to-css/)**.

## Setup

### CoffeeScript
```coffeescript
png = new PngToCss(
  onReturn: (result) ->
    console.log result
  
  onError: (error, type) ->
    console.error error, type
)
png.convert "image.png"
```

### JavaScript
```javascript
var png = new PngToCss({
  onReturn: function(result){
    console.log(result);
  },
  onError: function(error, type){
    console.error(error, type);
  }
});
png.convert('image.png');
```

## Events
<table>
  <tr>
    <th class="name">Name</th>
    <th class="provides">Provides</th>
    <th class="description">Description</th>
  </tr>
  <tr>
    <td>onReturn</td>
    <td>result</td>
    <td>Fires when converted css in ready</td>
  </tr>
  <tr>
    <td>onError</td>
    <td>error, type</td>
    <td>Fires when:<br />
        - path to image is invalid<br />
        - image format is not png
    </td>
  </tr>
</table>

## Requirements
PNG to CSS is written in CoffeeScript, and compiled into JavaScript. No need for frameworks.

## License
PNG to CSS is released under an MIT License.