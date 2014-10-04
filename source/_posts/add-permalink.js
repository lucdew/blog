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


   var dateRe = /^(20\d{2}-\d{2}-\d{2})-(.*)\.markdown$/; 
   var matches = dateRe.exec(f);
     var lines = fs.readFileSync(f).toString().split('\n'); 
     var headRe = /^---.*/;
     var started = false ; 
     var hasPermalink = false ; 
     var stopIdx = 0;
     var idx = 0;
     var addPermalink = false;

   if (matches && matches.length > 1) {
     lines.forEach(function(line) {
        if (stopIdx > 0 ) {
           return;
        }
        if (headRe.test(line) ) {
           if (!started) {
              started = true;
           }
           else {
              stopIdx = idx;
              addPermalink = !hasPermalink;
           }
        }
        if (/^\s*permalink\s*:.*$/.test(line)) {
           hasPermalink = true;
        }
        idx++;
     
     }) ;

     if (addPermalink) {
        console.log(f);
        count++;
        lines.insert(stopIdx,'permalink: '+matches[2]);
        fs.writeFileSync(f,lines.join('\n'));
     }

   
   }

});
console.log(count);
