function cycleColor(element) {
	var colors = ["red", "blue", "green", "yellow", "purple", "orange"];
	var currColor = findMatchingArrayElement(colors, element.className);
	var nextColor = findNextColor(colors, currColor);
	element.className = element.className.replace(colors[currColor], colors[nextColor]);
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