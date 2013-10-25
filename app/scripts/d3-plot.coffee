t = 1297110663
v = 70

next = ->
  return value =
    time: ++t
    value: v = ~~Math.max(10, Math.min(90, v + 10 * (Math.random() - .5)))

data = d3.range(45).map(next)
w = 10
h = 80

x = d3.scale.linear()
  .domain([0, 1])
  .range([0, w])

y = d3.scale.linear()
  .domain([0, 100])
  .rangeRound([0, h])

chart = d3.selectAll("#demo").append("svg")
  .attr("class", "chart")
  .attr("width", w * data.length - 1)
  .attr("height", h)
chart.selectAll("rect")
  .data(data)
  .enter().append("rect")
  .attr("x", (d, i) -> x(i) - .5)
  .attr("y", (d) -> h - y(d.value) - .5)
  .attr("width", w)
  .attr("height", (d) -> y(d.value))

redraw = ->
  rect = chart.selectAll("rect")
    .data(data, (d) -> d.time)
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
  data.shift()
  data.push next()
  redraw()
, 1500
