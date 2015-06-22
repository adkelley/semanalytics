$.getJSON('/static.json', function(data) {
    console.debug(data);
});
// var diameter = 960,
//     format = d3.format(",d"),
//     color = d3.scale.category20c();

// var bubble = d3.layout.pack()
//     .sort(null)
//     .size([diameter, diameter])
//     .padding(1.5);

// var svg = d3.select("body").append("svg")
//     .attr("width", diameter)
//     .attr("height", diameter)
//     .attr("class", "bubble");

// d3.json("static.json", function(error, root) {
//   if (error) throw error;

//   var node = svg.selectAll(".node")
//       .data(bubble.nodes(classes(root))
//       .filter(function(d) { return !d.children; }))
//       .enter().append("g")
//       .attr("class", "node")
//       .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

//   node.append("title")
//       .text(function(d) { return d.className + ": " + format(d.value); });

//   node.append("circle")
//       .attr("r", function(d) { return d.r; })
//       .style("fill", function(d) { return color(d.packageName); });

//   node.append("text")
//       .attr("dy", ".3em")
//       .style("text-anchor", "middle")
//       .text(function(d) { return d.className.substring(0, d.r / 3); });
// });

// // Returns a flattened hierarchy containing all leaf nodes under the root.
// function classes(root) {
//   var classes = [];

//   function recurse(name, node) {
//     if (node.children) node.children.forEach(function(child) { recurse(node.name, child); });
//     else classes.push({packageName: name, className: node.name, value: node.size});
//   }

//   recurse(null, root);
//   return {children: classes};
// }

// d3.select(self.frameElement).style("height", diameter + "px");
var custom_bubble_chart = (function(d3, CustomTooltip) {
    "use strict";

    var width = 940,
        height = 600,
        tooltip = CustomTooltip("twitter_tooltip", 240),
        layout_gravity = -0.01,
        damper = 0.1,
        nodes = [],
        vis, force, circles, radius_scale;

    var center = {
        x: width / 2,
        y: height / 2
    };

    var time_centers = {
        "Week": {
            x: width / 3,
            y: height / 2
        },
        "Day": {
            x: width / 2,
            y: height / 2
        },
        "Hour": {
            x: 2 * width / 3,
            y: height / 2
        }
    };

    var fill_color = d3.scale.ordinal()
        .domain(["low", "medium", "high"])
        .range(["#d84b2a", "#beccae", "#7aa25c"]);

    function custom_chart(data) {
        var max_amount = d3.max(data, function(d) {
            return parseInt(d.total_amount, 10);
        });
        radius_scale = d3.scale.pow().exponent(0.5).domain([0, max_amount]).range([2, 85]);

        //create node objects from original data
        //that will serve as the data behind each
        //bubble in the vis, then add each node
        //to nodes to be used later
        data.forEach(function(d) {
            var node = {
                id: d.id,
                radius: radius_scale(parseInt(d.total_amount, 10)),
                value: d.total_amount,
                name: d.grant_title,
                org: d.organization,
                group: d.group,
                year: d.start_year,
                x: Math.random() * 900,
                y: Math.random() * 800
            };
            nodes.push(node);
        });

        nodes.sort(function(a, b) {
            return b.value - a.value;
        });

        vis = d3.select("#vis").append("svg")
            .attr("width", width)
            .attr("height", height)
            .attr("id", "svg_vis");

        circles = vis.selectAll("circle")
            .data(nodes, function(d) {
                return d.id;
            });

        circles.enter().append("circle")
            .attr("r", 0)
            .attr("fill", function(d) {
                return fill_color(d.group);
            })
            .attr("stroke-width", 2)
            .attr("stroke", function(d) {
                return d3.rgb(fill_color(d.group)).darker();
            })
            .attr("id", function(d) {
                return "bubble_" + d.id;
            })
            .on("mouseover", function(d, i) {
                show_details(d, i, this);
            })
            .on("mouseout", function(d, i) {
                hide_details(d, i, this);
            });

        circles.transition().duration(2000).attr("r", function(d) {
            return d.radius;
        });

    }

    function charge(d) {
        return -Math.pow(d.radius, 2.0) / 8;
    }

    function start() {
        force = d3.layout.force()
            .nodes(nodes)
            .size([width, height]);
    }

    function display_group_all() {
        force.gravity(layout_gravity)
            .charge(charge)
            .friction(0.9)
            .on("tick", function(e) {
                circles.each(move_towards_center(e.alpha))
                    .attr("cx", function(d) {
                        return d.x;
                    })
                    .attr("cy", function(d) {
                        return d.y;
                    });
            });
        force.start();
        hide_times();
    }

    function move_towards_center(alpha) {
        return function(d) {
            d.x = d.x + (center.x - d.x) * (damper + 0.02) * alpha;
            d.y = d.y + (center.y - d.y) * (damper + 0.02) * alpha;
        };
    }

    function display_by_time() {
        force.gravity(layout_gravity)
            .charge(charge)
            .friction(0.9)
            .on("tick", function(e) {
                circles.each(move_towards_time(e.alpha))
                    .attr("cx", function(d) {
                        return d.x;
                    })
                    .attr("cy", function(d) {
                        return d.y;
                    });
            });
        force.start();
        display_times();
    }

    function move_towards_time(alpha) {
        return function(d) {
            var target = time_centers[d.year];
            d.x = d.x + (target.x - d.x) * (damper + 0.02) * alpha * 1.1;
            d.y = d.y + (target.y - d.y) * (damper + 0.02) * alpha * 1.1;
        };
    }


    function display_times() {
        var times_x = {
            "Week": 160,
            "Day": width / 2,
            "Hour": width - 160
        };
        var times_data = d3.keys(times_x);
        var times = vis.selectAll(".times")
            .data(times_data);

        times.enter().append("text")
            .attr("class", "times")
            .attr("x", function(d) {
                return times_x[d];
            })
            .attr("y", 40)
            .attr("text-anchor", "middle")
            .text(function(d) {
                return d;
            });

    }

    function hide_times() {
        var times = vis.selectAll(".times").remove();
    }


    function show_details(data, i, element) {
        d3.select(element).attr("stroke", "black");
        var content = "<span class=\"name\">Title:</span><span class=\"value\"> " + data.name + "</span><br/>";
        content += "<span class=\"name\">Amount:</span><span class=\"value\"> $" + addCommas(data.value) + "</span><br/>";
        content += "<span class=\"name\">Time:</span><span class=\"value\"> " + data.year + "</span>";
        tooltip.showTooltip(content, d3.event);
    }

    function hide_details(data, i, element) {
        d3.select(element).attr("stroke", function(d) {
            return d3.rgb(fill_color(d.group)).darker();
        });
        tooltip.hideTooltip();
    }

    var my_mod = {};
    my_mod.init = function(_data) {
        custom_chart(_data);
        start();
    };

    my_mod.display_all = display_group_all;
    my_mod.display_time = display_by_time;
    my_mod.toggle_view = function(view_type) {
        if (view_type == 'year') {
            display_by_time();
        } else {
            display_group_all();
        }
    };

    return my_mod;
})(d3, CustomTooltip);


d3.json("static.json", function(data) {
        custom_bubble_chart.init(data);
        custom_bubble_chart.toggle_view('all');
    });
 
$(document).ready(function() {
      $('#view_selection a').click(function() {
        var view_type = $(this).attr('id');
        $('#view_selection a').removeClass('active');
        $(this).toggleClass('active');
        custom_bubble_chart.toggle_view(view_type);
        return false;
      });
    });






