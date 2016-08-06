function cycleColor(element) {
	colors = ["red", "blue", "green", "yellow", "purple", "orange"]
	var currColor = findMatchingArrayElement(colors, element.className);
	var nextColor = findNextColor(colors, currColor);
	element.className = element.className.replace(colors[currColor], colors[nextColor]);
	updateGuess(element, colors)
};

function findMatchingArrayElement(colorArray, pegClass) {
	for (i = 0; i < colorArray.length; i++) {
		if (pegClass.indexOf(colorArray[i]) >= 0) {
			return(i);
		};
	};
};

function findNextColor(colorArray, index) {
	if (index === colorArray.length - 1) {
		return 0;
	} else {
		return index + 1;
	};
};

function updateGuess(element, colorArray) {
	var currGuess = document.getElementsByName("guess")[0].value
	var currPeg = parseInt(element.id) - 1
	var thisPegValue = parseInt(currGuess[currPeg])
	var newPegValue = findNextColor(colorArray, thisPegValue)
	var newGuess = currGuess.substring(0,currPeg) + newPegValue.toString() + currGuess.substring(currPeg+1,4)
	document.getElementsByName("guess")[0].value = newGuess
};