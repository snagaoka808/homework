// from data.js
var tableData = data;

// create tbody variable
var tbody = d3.select("tbody");

function buildTable(data) {
  tbody.html("");
  // loop for each data row
  data.forEach((dataRow) => {
    // append to table body
    var row = tbody.append("tr");
    // loop and add values
    Object.values(dataRow).forEach((val) => {
      var cell = row.append("td");
      cell.text(val);
    });
  });
}

// create container for filters
var filters = {};

function updateFilters() {

  // variables for changed element, value, and filter id
  var changedElement = d3.select(this).select("input");
  var elementValue = changedElement.property("value");
  var filterId = changedElement.attr("id");


  if (elementValue) {
    filters[filterId] = elementValue;
  }
  else {
    delete filters[filterId];
  }

  // function to filter
  filterTable();

}

function filterTable() {

  // set
  let filteredData = tableData;

  // loop through filters and keep filtered data
  Object.entries(filters).forEach(([key, value]) => {
    filteredData = filteredData.filter(row => row[key] === value);
  });

  // build table on filteredData
  buildTable(filteredData);
}

// create event for on changes
d3.selectAll(".filter").on("change", updateFilters);

// build table on tableData
buildTable(tableData);
