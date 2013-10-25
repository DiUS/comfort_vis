feeds = [
  { name: 'temperature', guid: 'a82ceb6076288dd0702e499b5c5658fd', colour: 'blue' },
  { name: 'pressure',    guid: '923235515ca20b8bfcb8201154c57264', colour: 'green' },
  { name: 'humidity',    guid: 'c9f7153540a45f3a35ca0a82f2501435', colour: 'red' },
  { name: 'light',       guid: 'b8f925d50eef3861912f7f1c9b1b98b2', colour: 'orange' },
  { name: 'altitude',    guid: '0c5639bd4ce7069c04ee1c474b6567f4', colour: 'purple' },
  { name: 'sound',       guid: 'd69395e3dac827c408fb2512dc69f97b', colour: 'black' },
  { name: 'gas',         guid: '9f0590f33ec088fdfcbbbb4ba0b69d84', colour: 'pink' }
]

plotit = (f) ->
  d3.json '/parsed_' + f.guid + '.json', (data) ->
    w = 10
    h = 70
    t = 2000

    shortdata = data[0...100]
    next = 100

    x = d3.scale.linear()
      .domain([0, 1])
      .range([0, w])

    min = d3.min((d.value for d in data))
    max = d3.max((d.value for d in data))
    y = d3.scale.linear()
      .domain([min-.1*(max-min), max])
      .rangeRound([0, h])

    chart = d3.selectAll("#" + f.name).append("svg")
      .attr("class", "chart")
      .attr("width", w * shortdata.length - 1)
      .attr("height", h)
    chart.selectAll("rect")
      .data(shortdata)
      .enter().append("rect")
      .style({'fill': f.colour})
      .attr("x", (d, i) -> x(i) - .5)
      .attr("y", (d) -> h - y(d.value) - .5)
      .attr("width", w)
      .attr("height", (d) -> y(d.value))

    redraw = ->
      rect = chart.selectAll("rect")
        .data(shortdata, (d) -> d.time)
      rect.enter().insert("rect", "line")
        .style({'fill': f.colour})
        .attr("x", (d, i) -> x(i + 10) - .5)
        .attr("y", (d) -> h - y(d.value) - .5)
        .attr("width", w)
        .attr("height", (d) -> y(d.value))
        .transition()
          .duration(t)
          .ease('linear')
          .attr("x", (d, i) -> x(i) - .5)
      rect.transition()
        .duration(t)
        .ease('linear')
        .attr("x", (d, i) -> x(i) - .5)
      rect.exit()
        .transition()
        .duration(t)
        .ease('linear')
        .attr("x", (d, i) -> x(i - 10))
        .remove()

    setInterval ->
      delta = 10
      shortdata.splice 0,delta
      shortdata = shortdata.concat data[next...next+delta]
      next += delta
      redraw()
    , t+100

plotit f for f in feeds
