from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    # Print "Hello, world!" to the console
    print('Hello, world!')
    return 'Hello, world!'

if __name__ == '__main__':
    # Print a startup message to the console
    print('Starting Flask server...')
    app.run(host='0.0.0.0', port=8000)  # Make sure it's accessible from the network
