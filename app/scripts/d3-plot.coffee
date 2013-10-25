feeds =
  temp:
    name: 'temperature'
    guid: 'a82ceb6076288dd0702e499b5c5658fd'
    xdomain: [0, 1]
    ydomain: [0, 50]
  pressure:
    name: 'pressure'
    guid: '923235515ca20b8bfcb8201154c57264'
    xdomain: [0, 1]
    ydomain: [0, 110000]
  humidity:
    name: 'humidity'
    guid: 'c9f7153540a45f3a35ca0a82f2501435'
    xdomain: [0, 1]
    ydomain: [0, 30]
  light:
    name: 'light'
    guid: 'b8f925d50eef3861912f7f1c9b1b98b2'
    xdomain: [0, 1]
    ydomain: [0, 160]
  altitude:
    name: 'altitude'
    guid: '0c5639bd4ce7069c04ee1c474b6567f4'
    xdomain: [0, 1]
    ydomain: [0, 90]
  mic:
    name: 'sound'
    guid: 'd69395e3dac827c408fb2512dc69f97b'
    xdomain: [0, 1]
    ydomain: [0, 15]
  gas:
    name: 'gas'
    guid: '9f0590f33ec088fdfcbbbb4ba0b69d84'
    xdomain: [0, 1]
    ydomain: [0, 150]

guid = 'c9f7153540a45f3a35ca0a82f2501435'
name = 'humidity'
xdomain = [0, 1]
ydomain = [0, 30]

d3.json '/parsed_' + guid + '.json', (data) ->
  w = 30
  h = 200

  shortdata = data[0...19]
  next = 20

  x = d3.scale.linear()
    .domain(xdomain)
    .range([0, w])

  y = d3.scale.linear()
    .domain(ydomain)
    .rangeRound([0, h])

  chart = d3.selectAll("#" + name).append("svg")
    .attr("class", "chart")
    .attr("width", w * shortdata.length - 1)
    .attr("height", h)
  chart.selectAll("rect")
    .data(shortdata)
    .enter().append("rect")
    .attr("x", (d, i) -> x(i) - .5)
    .attr("y", (d) -> h - y(d.value) - .5)
    .attr("width", w)
    .attr("height", (d) -> y(d.value))

  redraw = ->
    rect = chart.selectAll("rect")
      .data(shortdata, (d) -> d.time)
    rect.enter().insert("rect", "line")
      .attr("x", (d, i) -> x(i + 1) - .5)
      .attr("y", (d) -> h - y(d.value) - .5)
      .attr("width", w)
      .attr("height", (d) -> y(d.value))
      .transition()
      .duration(1000)
      .attr("x", (d, i) -> x(i) - .5)
    rect.transition()
      .duration(1000)
      .attr("x", (d, i) -> x(i) - .5)
    rect.exit().transition()
      .duration(1000)
      .attr("x", (d, i) -> x(i - 1) - .5)
      .remove()

  setInterval ->
    shortdata.shift()
    console.log data[next]
    shortdata.push data[next++]
    redraw()
  , 1500
