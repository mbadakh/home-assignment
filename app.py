import requests

from flask import Flask, request, render_template


app = Flask(__name__)
app.static_url_path = "/Static"
app.static_folder = app.root_path + app.static_url_path


@app.route("/", methods=['GET', 'POST'])
def main():
    return render_template('index.html')


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
