var path = require('path');

module.exports = {
  entry: './output/app.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname)
  }
};
