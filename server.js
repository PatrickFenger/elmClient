const express = require('express')
const app = express()


var counter = 0;
var add = function(req, res, next) {
    counter++;
    console.log("value of a counter in add" +counter)
    next();
}
var set = function(req, res, next) {
   counter = req.params.value
    next();
}
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });

app.get('/counter',[add], (req, res) => {
    res.send({counter})
});

app.post('/counter/:value',[set],(req, res)=> { 
    res.send({value})
})
app.disable('etag');
app.listen(5050, () => console.log('Example app listening on port 5050!'))