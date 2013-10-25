feeds = [
  { name: 'temperature', guid: 'a82ceb6076288dd0702e499b5c5658fd', colour: 'blue', textcolour: 'white' },
  { name: 'pressure',    guid: '923235515ca20b8bfcb8201154c57264', colour: 'green', textcolour: 'white' },
  { name: 'humidity',    guid: 'c9f7153540a45f3a35ca0a82f2501435', colour: 'red', textcolour: 'white' },
  { name: 'light',       guid: 'b8f925d50eef3861912f7f1c9b1b98b2', colour: 'orange', textcolour: 'black' },
  { name: 'altitude',    guid: '0c5639bd4ce7069c04ee1c474b6567f4', colour: 'purple', textcolour: 'white' },
  { name: 'sound',       guid: 'd69395e3dac827c408fb2512dc69f97b', colour: 'black', textcolour: 'white' },
  { name: 'gas',         guid: '9f0590f33ec088fdfcbbbb4ba0b69d84', colour: 'pink', textcolour: 'black' }
]

dateAndTime = (date) ->
  moment(date).format("HH:mm:ss")

plotit = (f) ->
  d3.json '/parsed_' + f.guid + '.json', (data) ->
    w = 10
    h = 200
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

    # FIXME: why is the y-scale here different to the one above?
    y2 = d3.scale.linear()
      .domain([min-.1*(max-min), max])
      .rangeRound([h, 0])
    yAxis = d3.svg.axis()
      .scale(y2)
      .orient("left")

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
    chart.selectAll("text")
      .data(shortdata)
      .enter().append("text")
      .text((d,i) -> if (i%10 == 0) then dateAndTime(new Date(Number(d.time)*1000)) else "")
      #.attr("text-anchor", "middle")
      .attr("x", (d, i) -> x(i) + 20)
      .attr("y", (d) -> h - 4)
      .attr("font-family", "sans-serif")
      .attr("font-size", "14px")
      .attr("fill", "black")
      .attr("fill", f.textcolour)  

    d3.select("#" + f.name).select("svg")
      .append("g")
      .attr("class", "axis")
      .attr("transform", "translate(998)")
      .call(yAxis)

    redraw = ->
      # FIXME: why do i have to remove and readd the vertical axis?
      d3.select("#" + f.name).select("svg").select("g").remove()

      rect = chart.selectAll("rect")
        .data(shortdata, (d) -> d.time)
      rect.enter()
        .insert("rect", "line")
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
      labels=chart.selectAll("text")
        .data(shortdata, (d) -> d.time)
      labels.enter()
        .append("text")
        .text((d,i) -> if (i%10 == 0) then dateAndTime(new Date(Number(d.time)*1000)) else "")
        .attr("x", (d, i) -> x(i + 10) - .5)
        .attr("y", (d) -> h - 4)
        .attr("font-family", "sans-serif")
        .attr("font-size", "14px")
        .attr("fill", "black")
        .attr("fill", f.textcolour)
        .transition()
          .duration(t)
          .ease('linear')
          .attr("x", w - 20)   
      labels.transition()
        .duration(t)
        .ease('linear')
        .attr("x", (d, i) -> x(i) - .5)
      labels.exit()
        .transition()
        .duration(t)
        .ease('linear')
        .attr("x", (d, i) -> x(i - 10))
        .remove()             
      

      d3.select("#" + f.name).select("svg")
        .append("g")
        .attr("class", "axis")
        .attr("transform", "translate(998)")
        .call(yAxis)

    setInterval ->
      delta = 10
      shortdata.splice 0,delta
      shortdata = shortdata.concat data[next...next+delta]
      next += delta
      redraw()
    , t+100

plotit f for f in feeds
