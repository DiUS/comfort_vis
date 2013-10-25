
# data = d3.range(45).map(next)
d3.json '/parsed_c9f7153540a45f3a35ca0a82f2501435.json', (data) ->
  w = 30
  h = 200

  shortdata = data[0...19]
  next = 20

  x = d3.scale.linear()
    .domain([0, 1])
    .range([0, w])

  y = d3.scale.linear()
    .domain([0, 30])
    .rangeRound([0, h])

  chart = d3.selectAll("#demo").append("svg")
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
