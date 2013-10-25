class window.Sparkline
  constructor: ->
    colours = d3.scale.category10().range()
    @feeds = [
      { color: colours[0], name: 'temperature', guid: 'a82ceb6076288dd0702e499b5c5658fd', unit: 'celcius' },
      { color: colours[1], name: 'pressure',    guid: '923235515ca20b8bfcb8201154c57264', unit: 'pascal' },
      { color: colours[2], name: 'humidity',    guid: 'c9f7153540a45f3a35ca0a82f2501435', unit: '%' },
      { color: colours[3], name: 'light',       guid: 'b8f925d50eef3861912f7f1c9b1b98b2', unit: 'lumens' },
      { color: colours[4], name: 'altitude',    guid: '0c5639bd4ce7069c04ee1c474b6567f4', unit: 'meters' },
      { color: colours[5], name: 'sound',       guid: 'd69395e3dac827c408fb2512dc69f97b', unit: 'dB' },
      { color: colours[6], name: 'gas',         guid: '9f0590f33ec088fdfcbbbb4ba0b69d84', unit: 'pascal' }
    ]

    s = 0
    e = s + 1000
    @data_window = {s: s, e: s + 100}
    @next = e

  plot: (f) =>
    d3.json '/parsed_' + f.guid + '.json', (source_data) =>
      data = [{values: source_data.slice(@data_window.s,@data_window.e), key: f.name, color: f.color}]

      redraw = =>
        nv.addGraph =>
          chart = nv.models.scatterChart()
            .x((d,i) -> new Date(Number(d.time)*1000))
            .y((d,i) -> d.value)
         
          chart.xAxis
            .axisLabel('Time')
            .tickFormat((t) ->
              d3.time.format('%I:%M:%S %p')(new Date(t))
            )
        
          chart.yAxis
            .axisLabel(f.unit)
            .tickFormat(d3.format('.02f'))

          d3.select("#nvd3_#{f.name} svg")
            .datum(data)
            .transition()
            .duration(1000)
            .call(chart)
       
          nv.utils.windowResize -> d3.select("#nvd3_#{f.name}").call(chart)

          return chart;

      redraw()

      # setInterval =>
      #   delta = 10
      #   d = data[0].values
      #   d.splice 0,delta
      #   data[0].values = d.concat source_data[@next...@next+delta]
      #   @next += delta
      #   redraw()
      # , 2000

  run: =>
    @plot f for f in @feeds

