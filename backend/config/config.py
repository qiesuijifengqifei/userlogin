import configparser
from os import path, makedirs
from config.frozen_dir import app_path

config_path = app_path() + 'config.ini'
config = configparser.ConfigParser()
config.read(config_path, encoding="utf-8")

data_path = app_path() + 'data/'
default_user = config['db']['user']
default_password = config['db']['password']
flask_port = config['flask']['port']
flask_debug = bool(config['flask']['debug'])

def do_config():

    if path.exists(data_path):
        print(data_path + ' already exists. Skip creation.')
    else:
        makedirs(data_path)

