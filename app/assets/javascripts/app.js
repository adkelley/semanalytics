//on window load
$(function() {
    var defaultQuery = "warriors"
    var minWC = "5" // min word count
    var maxWC = "100" // max word count
    var $submit = $('#submit-query');
    $submit.on("click", function(e) {
        e.preventDefault();
        if ($('svg.bubble').length > 0) {
            $('svg.bubble').remove()
        }
        query = $('#search-query').val() || defaultQuery;
        minWC = $('#min-word-count').val() || minWC
        maxWC = $('#max-word-count').val() || maxWC
        console.log(query);
        console.log(minWC);
        console.log(maxWC);
        if (query !== '') {
            $.get("/twitter/?query=" + encodeURIComponent(query) +
                "&min=" + minWC +
                "&max=" + maxWC).done(function(data) {
                //console.log(data);
                draw(data);
            });
        } else {
            alert("You must enter a search query");
        }

    });

    $.get("/twitter/?query=" + encodeURIComponent(defaultQuery) +
        "&min=" + minWC +
        "&max=" + maxWC).done(function(data) {
        draw(data);
    });
})


function draw(root) {
    var height = 960,
        width = 1260,
        format = d3.format(",d"),
        duration = 100,
        color = d3.scale.category20c();

    d3.select(self.frameElement).style("height", height + "px");

    var bubble = d3.layout.pack()
        .sort(null)
        .size([width, height])
        .padding(1.5);

    var svg = d3.select("body").append("svg")
        .attr("width", width)
        .attr("height", height)
        .attr("class", "bubble");

    var div = d3.select("body").append("div")
        .attr('class', 'tooltip')
        .style("opacity", 0);

    var node = svg.selectAll(".node")
        .data(bubble.nodes(classes(root))
            .filter(function(d) {
                return !d.children;
            }));
    node.enter().append("g")
        .attr("class", "node")
        .attr("transform", function(d) {
            return "translate(" + get_random(1, 959) + "," + get_random(1, 959) + ")";
        })
        .on("mouseover", function(d, i) {
            div.transition()
                .duration(200)
                .style("opacity", 0.9)
            div.html(d.className + "<br/>" + d.value)
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY - 28) + "px");
            show_details(d, i, this);
        })
        .on("mouseout", function(d, i) {
            div.transition()
                .duration(duration * 2.5)
                .style("opacity", 0);
            hide_details(d, i, this);
        });
    node.append("circle")
        .attr('r', 0)
        .style('opacity', 0)
        .style("fill", function(d) {
            return color(d.packageName);
        })
        .transition()
        .duration(duration * 30)
        .style('opacity', 1)
        .attr("r", function(d) {
            return d.r;
        });
    node.transition()
        .duration(duration * 60)
        .attr("transform", function(d) {
            return "translate(" + d.x + "," + d.y + ")";
        });

    node.append("text")
        .attr("dy", ".3em")
        .style('opacity', 0)
        .style("text-anchor", "middle")
        .text(function(d) {
            return d.className.substring(0, d.r / 3);
        })
        .transition()
        .duration(duration * 50)
        .style('opacity', 1);

        var defaultQuery = "warriors"
        var minWC = "5" // min word count
        var maxWC = "100" // max word coun
        var $text = $('text');
        $text.on("click", function(e) {
                e.preventDefault();
                if ($('svg.bubble').length > 0 && $(this).text()) {
                    $('svg.bubble').remove();
                    $('.tooltip').remove()
                }
                query = $(this).text() || defaultQuery;
                $.get("/twitter/?query=" + encodeURIComponent(query) +
                    "&min=" + minWC +
                    "&max=" + maxWC).done(function(data) {
                    //console.log(data);
                    draw(data);
                });
                console.log($(this).text());

            });

}

// Returns a flattened hierarchy containing all leaf nodes under the root.
function classes(root) {
    var classesArr = [];

    function recurse(name, node) {
        if (node.children) node.children.forEach(function(child) {
            recurse(node.name, child);
        });
        else classesArr.push({
            packageName: name,
            className: node.name,
            value: node.size
        });
    }

    recurse(null, root);
    return {
        children: classesArr
    };
}

function show_details(d, i, element) {
    d3.select(element).attr("stroke", "black");
}

function hide_details(d, i, element) {
    d3.select(element).attr("stroke", "null");
}

function get_random(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}