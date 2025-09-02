import http.server
import socketserver

# Set the port number for the web server
PORT = 8080

# Define a custom handler that serves a simple "Hello, World!" message
class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Set the HTTP response status code to 200 (OK)
        self.send_response(200)

        # Set the Content-Type header to text/plain
        self.send_header("Content-type", "text/plain")
        self.end_headers()

        # Send the "Hello, World!" message as bytes
        self.wfile.write(b"Hello, World!")

# Create a TCP server instance that uses the custom handler
with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
    print(f"Serving at port {PORT}")
    print("Open your web browser and navigate to http://localhost:8080 to see the output.")

    # Start the server and serve requests indefinitely
    httpd.serve_forever()
