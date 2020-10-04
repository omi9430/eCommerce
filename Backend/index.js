// Add Pacakges we need

const express = require('express')
const bodyParser = require('body-parser')
var stripe = require('stripe')('sk_test_cAQ7ApjMK2207VnZLZkLO93x00aF6AhOat')

const app = express()

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
  extended : true
}))

app.get('/', function(req, res){
  res.send('Hello Umair')
})

app.post('/charge', (req, res) => {
  var description = req.body.description
  var amount = req.body.amount
  var currency = req.body.currency
  var token = req.body.token

  console.log(req.body)

  stripe.charges.create({
    source: token,
    amount: amount,
    currency: currency,
    description: description
  },function(err, charge){
  if (err) {
    console.log(err, req.body)
    res.status(500).end()
  } else {
    console.log('success')
    req.satus(200).send()
  }
})
});

app.listen(3000, () => {
  console.log('local host running on port 3000')
})
