var xView = "poverty";
var yView = "healthcare";
var state_text = "State: ";


d3.csv("./assets/data/data.csv")
.then(function(dataset){
  showVisual(dataset, xView, yView); 
});

var svgHeight = 500;
var svgWidth = 900; 

var margin = { top: 50, right: 50, bottom: 20, left: 50 };
var padding ={ top: -50, right: 20, left: 40 }

var width = svgWidth - margin.left - margin.right;
var height = svgHeight - margin.top - margin.bottom;

// SVG 
var svg = d3
  .select("#scatter")
  .append("svg")
  .attr("width", width)
  .attr("height", height)
  .attr("class", "scatter")
  .append("g")
  .attr("tranform", `translate( ${margin.left}, ${margin.top})`);

// function for visual
function showVisual(dataset, xView, yView){
  
  // load
  dataset.map(d => {
    dataset.state = dataset.state;
    dataset.abbr = dataset.abbr;
    dataset.poverty = +d[xView];
    dataset.healthcare = +d[yView];
    });
    
  

  var xValues  = dataset.map(d => parseFloat(d[xView]));
  var yValues  = dataset.map(d => parseFloat(d[yView]));
  

  //scale data
  var xLinearScale = d3.scaleLinear() 
    .domain([d3.min(xValues)-1, d3.max(xValues)+0.5])
    .range([margin.left, width + margin.left]);

  var yLinearScale = d3.scaleLinear()
    .domain([d3.min(yValues)-1, d3.max(yValues)+0.5])
    .range([height - margin.top, margin.top]); 

  
  // functions for axis
  var xAxis = d3.axisBottom(xLinearScale);
  var yAxis = d3.axisLeft(yLinearScale);
  
  svg.append("g")
    .attr("class", "xAxis")
    .attr("transform", `translate(${0}, ${height - margin.bottom-30})`)
    .call(xAxis);

  svg.append("g")
    .attr("class", "yAxis")
    .attr("transform", `translate(${margin.left+10}, ${0})`)
    .call(yAxis);
  
  
  // scatter chart
  var scatter = svg.selectAll("circle")
    .data(dataset)
    .enter()
    .append("circle")
    .attr("cx", d => xLinearScale(d[xView]))
    .attr("cy", d => yLinearScale(d[yView]))
    .attr("r", 10)
    .attr("fill", "#0066cc")
    .attr("opacity", ".5")


  
  // append bubble text
  svg.append("text")
    .style("text-anchor", "middle")
    .style("font-size", "10px")
    .style("font-weight", "bold")
    .style("font-family", "arial")
    .selectAll("tspan")
    .data(dataset)
    .enter()
    .append("tspan")
    .attr("x", function(data) {
        return xLinearScale(data.poverty - 0);
      })
    .attr("y", function(data) {
        return yLinearScale(data.healthcare - 0.1);
      })
    .text(function(data) {
        return data.abbr
      });    
  
  // x-axis label
  svg.append("text")
    .style("font-family", "arial")
    .style("text-anchor", "middle")
    .style("font-size", "18px")
    .attr("transform", `translate(${width/2}, ${height - margin.top + 40})`)
    .attr("class", "axisText")
    .text("In Poverty (%)");

  // y-axis label
  svg.append("text")
    .style("font-family", "arial")
    .style("text-anchor", "middle")
    .style("font-size", "18px")
    .attr("transform", "rotate(-90)")
    .attr("y", 0 + 5)
    .attr("x", 0 - (height/2))
    .attr("dy","1em")
    .attr("class", "axisText")
    .text("Lacks Healthcare (%)");

  
  
};