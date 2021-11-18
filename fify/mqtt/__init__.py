topicHandler = {}

def add_topic_handler(topic, handler):
    global topicHandler
    topicHandler[topic] = handler