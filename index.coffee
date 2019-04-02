# CPU History widget for ubersicht

command: """
  r=$(top -n 1 -l 1|grep "CPU usage");eval "arr=($r//%/)";
  echo "${arr[2]//%/} ${arr[4]//%/} ${arr[6]//%/}"
"""

# The refresh frequency in milliseconds
refreshFrequency: 5000

# Change container size to change the sizing of the chart
render: (domEl) -> """
<script src="https://code.highcharts.com/stock/highstock.js"></script>
<div id="container" style="width:290em; height:15em;">Loading...</div>    
"""
  
afterRender: (domEl) ->
  Highcharts.setOptions({
    global: {
      useUTC: false # UTC is set by default, disabling it triggers highcharts to pick up browser's local time
    }
  })
  
  $(domEl).find('#container').highcharts('StockChart'
    colors: ['#6fc3df', '#6fc3df','#6fc3df']
    chart:   
      marginRight: 1
      marginTop: 1
      marginBottom: 8
      animation: Highcharts.svg
      useUTC: false
      backgroundColor: 'transparent'
      style:
        color: '#7FD8BE'
        fontFamily:'Helvetica Neue'
        fontSize: '8px'
    navigator:
      enabled: false
    rangeSelector:
      enabled:false
      buttons:
        [{
        count: 5
        type: 'minute'
        text: '5M',
        },{
        connt: 10
        type: 'minute'
        text: '10M'
        },{
        type: 'all'
        text: 'All'
        }]
      enabled: false
      inputEnabled: false
      selected:0
      #inputEnabled: false
      #buttonTheme: visibility: 'hidden'
      #labelStyle: visibility: 'hidden'
      
    scrollbar:
      enabled:false

    title:
      text: 'CPU'
      enabled: false
      style:
        color: 'rgba(126, 255, 255, 0.50)'
        fontSize: '10px'
        fontFamily:'Helvetica Neue'
#========================
    xAxis:
      type: 'datetime'
      dateTimeLabelFormats:
        hour: '%I :%p'
        minute: '%I:%M %p'
        useUTC: false
        #minTickInterval: 600
        #min: 90
        tickPixelInterval: 90
      minRange: 15*24
      labels:
        enabled: true
        #padding: -5
        y: 8
        style:
          color: '#7FD8BE'
          fontSize: '8px'

      #gridLineColor: 'transparent'
#        null
      lineWidth: 0
      gridLineWidth: 0
      minorGridLineWidth: 0
      minorTickLenght: 0
      tickLength: 0
      lineColor: 'transparent'
      plotLines:[{
        width: 0
        value: 0
        color: 'rgba(126, 255, 255, 0.50)'
        }]
# ==================================
    yAxis:
      lineColor: 'transparent'          
      offset: -5
      title:
        text: null
        style: color: 'rgba(126, 255, 255, 0.50)'
      plotLines:[{
        value: 0
        width: 0.5
        color: '#7FD8BE'
      }]
      labels:
        style:
          color: 'rgba(126, 255, 255, 0.50)'
          fontSize: '8px'
        y: 7

      #tickPosition:"inside"      
      #padding: 0
      #stackLabels: true
      #reserveSpace: false
      showFirstLabel: false
      showLastLabel: true
      gridLineColor: null

      legend:
        enabled: false
        verticalAlign: 'top'
        # align: 'top'
        floating: true

# ==========================
# Here is where you put data
# Dynamically fed by update code below
    series: [ {
      name: 'User'
      lineWidth: 1
      color: '#F0544F'
      data: []
      },
      {
       name: "Sys"
       lineWidth: 1
       color:"#F28F3B"
       data:[]
      },
      {
       name: "Idle"
       lineWidth: 1
       color:"#00FDDC"
       data:[]
        }]
      
    credits:
      enabled: false
  )

update:(output,domEl) ->
  #How to dynamically update data for highcharts/stock    #http://stackoverflow.com/questions/16061032/highcharts-series-data-array  #http://stackoverflow.com/questions/13049977/how-can-i-get-access-to-a-highcharts-chart-through-a-dom-container
  #http://api.highcharts.com/highstock/Series.addPoint()
  @run """
    r=$(top -n 1 -l 1|grep "CPU usage");eval "arr=($r//%/)";
    echo "${arr[2]//%/} ${arr[4]//%/} ${arr[6]//%/}"
   """, (err, output) ->

      data=output.split(" ");
      console.log(data)
      cpuuser = parseFloat(data[0]);
      cpusys = parseFloat(data[1]);
      cpuidle = parseFloat(data[2]);
      chart=$(domEl).find("#container").highcharts();
      time= (new Date).getTime();
      #timeData = time + i * 10000;  
      chart.series[0].addPoint([time, cpuuser], true);
      chart.series[1].addPoint([time, cpusys], true);
      chart.series[2].addPoint([time, cpuidle], true);
      
# the CSS style for this widget, written using Stylus
# (http://learnboost.github.io/stylus/)
style: """

  font-family: Helvetica Neue
  font-weight: 300
  bottom: 0em
  left: 0%
  text-shadow: 0 0 1px rgba(#000, 0.5)
  font-size: 5px
  white-space: pre
"""
