from flask import Flask

# Create a Flask web application instance.
app = Flask(__name__)

# Define the route for the home page ('/').
@app.route('/')
def hello_world():
    """
    Returns a simple "Hello, World!" message.
    """
    return "Hello, World!"

# This block runs the server when the script is executed directly.
if __name__ == '__main__':
    # Run the Flask app on host '0.0.0.0' to make it accessible
    # from outside the Docker container, on port 8080.
    app.run(host='0.0.0.0', port=8080)
