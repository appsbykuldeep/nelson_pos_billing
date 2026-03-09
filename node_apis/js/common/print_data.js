const {serverInfo} = require("./env_setup")
let isdev =  serverInfo["isLocal"] == true || false;
const datetime = require("./datetime");




function print(data,...other){
    if(isdev){
        console.log(datetime.getCurrentTimeStamp(true),data,other);

        // setInterval(() => {
        //   debounce(()=>{
        //     console.clear();
        // },1000);
        // }, 3000); 
    
    
    }
}



// Debounce function (waits before running again)
function debounce(func, delay) {
    let timer;
    return (...args) => {
      clearTimeout(timer);
      timer = setTimeout(() => {
        func(...args);
      }, delay);
    };
  }
  
//   // Function to run
//   function myTask() {
//     console.log('Running at', new Date().toISOString());
//   }
  
//   // Debounced version
//   const debouncedTask = debounce(myTask, 1000); // 1s debounce
  
//   // Interval trigger
//   setInterval(() => {
//     debouncedTask(); // will only run once per debounce period
//   }, 300); // calling every 300ms
  




exports.print = print;