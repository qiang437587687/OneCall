# # coding: utf-8
#
# from datetime import datetime
#
# from flask import Flask
# from flask import render_template
# from flask_sockets import Sockets
#
# from views.todos import todos_view
#
# app = Flask(__name__)
# sockets = Sockets(app)
#
# # 动态路由
# app.register_blueprint(todos_view, url_prefix='/todos')
#
#
# @app.route('/')
# def index():
#     return render_template('index.html')
#
#
# @app.route('/time')
# def time():
#     return str(datetime.now())
#
#
# @sockets.route('/echo')
# def echo_socket(ws):
#     while True:
#         message = ws.receive()
#         ws.send(message)


# coding: utf-8

from datetime import datetime

from flask import Flask
from flask import render_template
from flask_sockets import Sockets

from flask import request

import json

import requests

app = Flask(__name__)
sockets = Sockets(app)

# 动态路由
# app.register_blueprint(todos_view, url_prefix='/todos')

headers = {
    'X-LC-Id': 'lqneCtEOG1bN2yTJ9gafPc20-gzGzoHsz',
    'X-LC-Key': 'GxVivHpa9rnFo0GM7NAnLjqB',
    # 'Content-Type': 'application/json'
}

@app.route('/')
def index():
    return "welcome"


@app.route('/time')
def time():
    return str(datetime.now())


@sockets.route('/echo')
def echo_socket(ws):
    while True:
        message = ws.receive()
        ws.send(message)


@app.route('/zhangxianqiang')
def zhangxianqiang():
    print("call zhangxianqiang")
    return "onecallex"



@app.route('/leavechannel',methods=['POST'])
def leave():

    otherChannel = request.form.get("otherChannel")  # 这个是需要发送给对方的频道。在这个频道里面会有推送。
    dic = {
        "prod": "dev",
        "channels": [otherChannel],
        "data": {
            "rquestChannel": "",
            "pushEvent": "1"
        }
    }

    return requestMethod(url='https://lqnecteo.push.lncld.net/1.1/push', json=dic, headers=headers)


@app.route('/pushchannel', methods=['POST'])
def push():
    if request.method == 'POST':
        #datax = request.get_json()
        #data = request.data
        #j_data = json.loads(data)
        channel = request.form.get("channel") #这个是发送的频道 需要对方进入这个频道。
        otherChannel = request.form.get("otherChannel")   # 这个是需要发送给对方的频道。在这个频道里面会有推送。
        '''
  curl -X POST \
  -H "X-LC-Id: lqneCtEOG1bN2yTJ9gafPc20-gzGzoHsz"          \
  -H "X-LC-Key: GxVivHpa9rnFo0GM7NAnLjqB"        \
  -H "Content-Type: application/json" \
  -d '{
        "channels":[ "public"],
        "data": {
          "alert": "LeanCloud 向您问好！"
        }
      }' \
  https://lqnecteo.push.lncld.net/1.1/push
'''
        # 请求数据 ---> 发送推送。
        '''
        headers = {
            'X-LC-Id': 'lqneCtEOG1bN2yTJ9gafPc20-gzGzoHsz',
            'X-LC-Key': 'GxVivHpa9rnFo0GM7NAnLjqB',
            # 'Content-Type': 'application/json'
        }'''

        dic = {
            "prod": "dev",
            "channels": [otherChannel],
            "data": {
                "alert": "消息内容",
                "category": "通知类型",
                "thread-id":  "通知分类名称",
                "rquestChannel": channel,
                "pushEvent":"0"
                }
        }

        # params = json.dumps(dic) # 转为字符串

        #print(params)

        #r = requests.post('https://lqnecteo.push.lncld.net/1.1/push', json=dic, headers=headers)
        #print(r.status_code)
        #print(r.text)
        return requestMethod(url='https://lqnecteo.push.lncld.net/1.1/push',json=dic,headers=headers)


# 这个是实际的请求函数
def requestMethod(url,json,headers):

    r = requests.post(url, json=json, headers=headers)
    print(r.status_code)
    print(r.text)

    return "code === %d backmessage===%s" % (r.status_code, r.text)



if __name__ == '__main__':
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=False
    )
