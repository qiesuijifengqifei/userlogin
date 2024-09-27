import configparser
from os import path, makedirs
from config.frozen_dir import app_path

config_path = app_path() + 'config.ini'
config = configparser.ConfigParser()
config.read(config_path, encoding="utf-8")

class Config:
    data_path = app_path() + 'data/'

    default_user = config['db']['user']
    default_password = config['db']['password']
    app_port: int = int(config['app']['port'])
    app_host = config['app']['host']
    app_threads: int = int(config['app']['threads'])

    def do_config():

        if path.exists(Config.data_path):
            print(Config.data_path + ' already exists. Skip creation.')
        else:
            makedirs(Config.data_path)

