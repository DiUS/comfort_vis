class window.Sparkline

  constructor: ->

    d3.json '/parsed_c9f7153540a45f3a35ca0a82f2501435.json', (data) ->
      model = -> [ {values: data.splice(0,1000), key: 'Noise', color: '#ff7f0e'} ]

      nv.addGraph ->
        chart = nv.models.lineChart()
          .x((d,i) -> d.time)
          .y((d,i) -> d.value)
       
        chart.xAxis
          .axisLabel('Time')
          .tickFormat((time) ->
            d3.time.format('%I:%M %p')(new Date(time))
          )
      
        chart.yAxis
          .axisLabel('??')
          .tickFormat(d3.format('.02f'))
        d3.select('#sparkline svg')
          .datum(model())
          .transition()
          .duration(500)
          .call(chart)
     
        nv.utils.windowResize -> d3.select('#sparkline').call(chart)

        return chart;

