const express = require('express')
const app = express()
const port = process.env.PORT || 5001 ;

app.get('/', (req, res) => {
    res.send('Sample NodeJS application!')
  })

app.listen(port, () => {
  console.log(`|x| Browsing the application using PORT ${port}`)
})