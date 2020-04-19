// function to generate a password
((length = 10) => {
	const lowerCaseLetters = [
		'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
		'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
	];
	const upperCaseLetters = [
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
		'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
	];
	const numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',];
	const symbols = [
		// '!', '-', '_', '+', '='
		'!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+',
		'[', '{', ']', '}', '|', ';', ':', ',', '<', '.', '>', '/', '?'
	];
	function getRandomInt(max) {
		// generates a random int from 0 to max-1
		return Math.floor(Math.random() * Math.floor(max));
	};
	function genCharFunc(arr) {
		return function(count = 2) {
			var ret = '', idx;
			for (let i = 0; i < count; i++) {
				idx = getRandomInt(arr.length);
				ret += arr[idx];
			}
			return ret;
		};
	};
	const getLower = genCharFunc(lowerCaseLetters);
	const getUpper = genCharFunc(upperCaseLetters);
	const getNumber = genCharFunc(numbers);
	const getSymbol = genCharFunc(symbols);
	function shuffleArr(arr) {
		const ret = [];
		for(let i = arr.length - 1; i >= 0; i--) {
			ret.push(arr.splice(getRandomInt(i), 1)[0]);
		}
		return ret;
	};
	const funcArr = shuffleArr([getLower, getUpper, getNumber, getSymbol]);
	var password = '', i = 0;
	while(password.length < length) {
		password += funcArr[i]();/* default 2 chars of each */
		i++;
		if (i >= funcArr.length) {
			i = 0;
		}
	}
	return password.substr(0, length);
})();
