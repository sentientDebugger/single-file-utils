((desiredPwdlength = 15) => {
  // function to generate a password
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
  function getRandomInt(min, max) {
    // generates a random int from min to max (both inclusive)
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };
  function genCharFunc(arr) {
    return function(count = 2) {
      let ret = '', idx;
      for (let i = 0; i < count; i++) {
        idx = getRandomInt(0, arr.length - 1);
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
      ret.push(arr.splice(getRandomInt(0, i), 1)[0]);
    }
    return ret;
  };
  const funcArr = shuffleArr([getLower, getUpper, getNumber, getSymbol]);
  let password = '', i = 0;
  while (password.length < desiredPwdlength) {
    password += funcArr[i](getRandomInt(1, 4));/* 1 to 4 chars of each */
    i++;
    if (i >= funcArr.length) {
      i = 0;
    }
  }
  return password.substring(0, desiredPwdlength);
})();
