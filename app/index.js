const http = require('http');
const port = 3000;

http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/plain" });
  res.end("Hello from Node.js running on EC2 with Docker!\n");
}).listen(port, '0.0.0.0', () => {
  console.log(`Server running on port ${port}`);
});
