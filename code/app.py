from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    print('Hello, world!')

if __name__ == '__main__':
    app.run()

#This is a test