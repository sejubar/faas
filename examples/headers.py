from flask import request
def main():
    try:
        myHeader = request.headers['x-my-header']
    except KeyError:
        return "Header 'x-my-header' not found"
    return f"header updated: {myHeader}"