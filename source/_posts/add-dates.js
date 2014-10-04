var fs=require('fs');

var fs = require('fs');

function getFiles() {
  return fs.readdirSync('.').filter(function (file) {
    return fs.statSync(file).isFile();
  });
}


var files = getFiles();

Array.prototype.insert = function (index, item) {
  this.splice(index, 0, item);
};

var count=0;

files.forEach(function(f){

   var dateRe = /^(20\d{2}-\d{2}-\d{2})-.*$/; 
   var matches = dateRe.exec(f);
     var lines = fs.readFileSync(f).toString().split('\n'); 
     var headRe = /^---.*/;
     var inFileDateRe = /^date\s?:.*/;
     var started = false ; 
     var hasDate = false ; 
     var startIdx = 0;
     var idx = 0;
   if (matches && matches.length > 1) {
     lines.forEach(function(line) {
        if (headRe.test(line) && ! started) {
              started = true;
              startIdx = idx;
        }
        if (inFileDateRe.test(line)) {
           hasDate = true;
        }
        idx++;
     
     }) ;

     if (!hasDate && started) {
        console.log(f);
        count++;
        lines.insert(startIdx+2,'date: '+matches[1]);
        fs.writeFileSync(f,lines.join('\n'));

     
     }

   
   }

});
console.log(count);
