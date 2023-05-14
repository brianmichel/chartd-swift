# chartd-swift

A small library to easily construct URLs for [ChartD](https://chartd.co)

This service lets you construct simple graphs as images to easily send them around in places where it might not be convenient to upload a file to.

A good example for where this can be helpful is when building automations into Slack (or any messaging service). You want to show a graph or a chart, but don't feel like generating the chart image yourself, storing it somewhere that Slack can access it, and then including the URL.

Just use a chartd URL to get that graphical information right into your service!

## Usage
Instantiate a builder, and add the properties you would like to help define your chart. Please note, the following poperties are **mandatory**:
- height
- width
- at least 1 dataset (but no more than 5)

After you've configured the builder, simply call `.url()`, optionally you can specify if you want a PNG or SVG version of your chart in this call as well.

Here's a complete example:

```swift
let url = try ChartDURLBuilder()
    .height(200)
    .width(400)
    .datasets([
        .init(data: "98851"), // pass in a pre-encoded string for your data
        .init(data: [0.1, 0.0, 0.8, 0.9].base62encode(minimum: 0.0, maximum: 1.0)) // or, encode the data on the fly.
     ])
     .url()
```
