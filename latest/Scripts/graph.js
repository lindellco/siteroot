var inputListA = new Array();
inputListA.push({ tag: "#dog", freq: 34 });
inputListA.push({ tag: "#bird", freq: 164 });
inputListA.push({ tag: "#cat", freq: 32 });
inputListA.push({ tag: "#fish", freq: 103 });
inputListA.push({ tag: "#snake", freq: 82 });

var inputListB = new Array();
inputListB.push({ tag: "#bird", freq: 155 });
inputListB.push({ tag: "#cat", freq: 22 });
inputListB.push({ tag: "#fish", freq: 75 });
inputListB.push({ tag: "#snail", freq: 44 });
inputListB.push({ tag: "#chipmunk", freq: 142 });


var combinedInput = new Array();

function findTag(element, list) {
    for (k = 0; k < list.length; k++) {
        if ((list[k].tag.localeCompare(element)) == 0) {
            return list[k].freq;
            break;
        }
    }
    return 0;

}

function findLeftOvers(ListB, ListA) {
    var leftOvers = new Array();

    for (var i = 0; i < ListB.length; i++) {
        if (findTag(ListB[i].tag, ListA) == 0) {
            leftOvers.push(ListB[i]);
        }
    }
    if (leftOvers != null) {
        return leftOvers;
    } else return [];
}





var inputXAxis = "#Pets";
var inputYAxis = "#petsAREfamily";


function drawBase() {
    var ctx = document.getElementById('my_canvas').getContext('2d');

    ctx.beginPath();
    ctx.moveTo(100, 25);
    ctx.lineTo(100, 425);
    ctx.lineTo(500, 425);

    ctx.stroke();

    ctx.fillstyle = '#FC0';
    ctx.font = '10px Arial, sans-serif';
    ctx.fillText(inputXAxis, 300, 455);

    ctx.save();
    ctx.rotate(3.14 / 2);
    ctx.fillText(inputYAxis, 200, -67);

    ctx.restore();



    var xMinBound = 0;
    var xMaxBound = 10;
    var yMinBound = 0;
    var yMaxBound = 10;

    //document.write(parseInt(getMinFreq(inputListA)/10, 10)*10);

    function getBounds() {

        xMaxBound = Math.ceil((getMaxFreq(inputListA)) / 10) * 10;
        yMaxBound = Math.ceil((getMaxFreq(inputListB)) / 10) * 10;
        xMinBound = parseInt(getMinFreq(inputListA) / 10, 10) * 10;
        yMinBound = parseInt(getMinFreq(inputListB) / 10, 10) * 10;

        if (xMaxBound > yMaxBound) {
            yMaxBound = xMaxBound;
        } else {
            xMaxBound = yMaxBound;
        }

        if (xMinBound < yMinBound) {
            yMinBound = xMinBound;
        } else {
            xMinBound = yMinBound;
        }

    }

    function drawBounds() {


        for (var i = 100; i <= 500; i += 40) {
            ctx.moveTo(i, 422);
            ctx.lineTo(i, 428);

            if (((i - 100) / 40) > 0) {
                ctx.fillText(((xMaxBound / 10) * ((i - 100) / 40)), i - 4, 440);
            } else {
                ctx.fillText(0, i - 4, 440);
            }

        }



        for (var i = 425; i >= 25; i -= 40) {
            ctx.moveTo(97, i);
            ctx.lineTo(103, i);

            if (((425 - i) / 40) > 0) {
                ctx.fillText(((yMaxBound / 10) * ((425 - i) / 40)), 83, i + 4);
            } else {
                ctx.fillText(0, 83, i + 4);
            }
        }
        ctx.stroke();

    }


    //function getBounds(){
    //					
    //	xMaxBound = getMaxFreq(inputListA) + 5;
    //	yMaxBound = getMaxFreq(inputListB) + 5;
    //	xMinBound = getMinFreq(inputListA) - 5;
    //	yMinBound = getMinFreq(inputListB) - 5;
    //
    //}

    function getMaxFreq(input) {

        var max = 0;
        for (var i = 0; i < input.length; i++) {
            if (input[i].freq > max) {
                max = input[i].freq;
            }
        }

        return max;
    }

    function getMinFreq(M) {

        var min = 1000;
        for (var i = 0; i < M.length; i++) {

            if (M[i].freq < min) {
                min = M[i].freq;
            }
        }

        return min;
    }


    getBounds();
    drawBounds();

    function drawPoints() {
        for (var i = 0; i < inputListA.length; i++) {

            var xPos = 100 + ((inputListA[i].freq / xMaxBound) * 400);
            var yPos = 425 - ((findTag(inputListA[i].tag, inputListB) / yMaxBound) * 400);


            ctx.fillRect(Math.floor(xPos) - 3, Math.floor(yPos) - 3, 5, 5);
            ctx.fillText(inputListA[i].tag, Math.floor(xPos + 10), Math.floor(yPos));


        }
        var leftOvers = findLeftOvers(inputListB, inputListA);

        for (var j = 0; j < leftOvers.length; j++) {

            var xPos = 100;
            var yPos = 425 - ((leftOvers[j].freq / xMaxBound) * 400);

            ctx.fillRect(Math.floor(xPos) - 3, Math.floor(yPos) - 3, 5, 5);
            ctx.fillText(leftOvers[j].tag, Math.floor(xPos + 10), Math.floor(yPos));
        }
    }
    drawPoints();


}
window.onload = drawBase;