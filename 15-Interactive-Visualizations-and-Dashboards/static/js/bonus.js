

function buildGauge(wfreq) {
    
    var level = parseFloat(wfreq) * 20;
  
    
    var degrees = 180 - level;
    var radius = 0.5;
    var radians = (degrees * Math.PI) / 180;
    var x = radius * Math.cos(radians);
    var y = radius * Math.sin(radians);
  
    
    var mainPath = "M -.0 -0.05 L .0 0.05 L ";
    var pathX = String(x);
    var space = " ";
    var pathY = String(y);
    var pathEnd = " Z";
    var path = mainPath.concat(pathX, space, pathY, pathEnd);
  
    var data = [
      {
        type: "scatter",
        x: [0],
        y: [0],
        marker: { size: 14, color: "110000" },
        showlegend: false,
        name: "Frequency",
        text: level,
        hoverinfo: "text+name"
      },
      {
        values: [50 / 9, 50 / 9, 50 / 9, 50 / 9, 50 / 9, 50 / 9, 50 / 9, 50 / 9, 50 / 9, 50],
        rotation: 90,
        text: ["8-9", "7-8", "6-7", "5-6", "4-5", "3-4", "2-3", "1-2", "0-1", ""],
        textinfo: "text",
        textposition: "inside",
        marker: {
          colors: [
            "rgba(51, 239, 51, .3)",
            "rgba(110, 239, 51, .3)",
            "rgba(132, 239, 51, .3)",
            "rgba(179, 239, 51, .3)",
            "rgba(214, 239, 51, .3)",
            "rgba(239, 236, 51, .3)",
            "rgba(239, 201, 51, .3)",
            "rgba(239, 164, 51, .3)",
            "rgba(239, 117, 51, .3)",
            "rgba(239, 79, 51, .3)"
          ]
        },
        labels: ["8-9", "7-8", "6-7", "5-6", "4-5", "3-4", "2-3", "1-2", "0-1", ""],
        hoverinfo: "label",
        hole: 0.5,
        type: "pie",
        showlegend: false
      }
    ];
  
    var layout = {
      shapes: [
        {
          type: "path",
          path: path,
          fillcolor: "110000",
          line: {
            color: "110000"
          }
        }
      ],
      title: "Belly Button Washing Frequency <br> Scrub per Week",
      height: 550,
      width: 550,
      xaxis: {
        zeroline: false,
        showticklabels: false,
        showgrid: true,
        range: [-1, 1]
      },
      yaxis: {
        zeroline: false,
        showticklabels: false,
        showgrid: true,
        range: [-1, 1]
      }
    };
  
    var GAUGE = document.getElementById("gauge");
    Plotly.newPlot(GAUGE, data, layout);
  }