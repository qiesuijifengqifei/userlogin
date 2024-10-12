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
    app_logfile: bool = config['app']['logfile']

    def do_config():

        if path.exists(Config.data_path):
            print(Config.data_path + ' already exists. Skip creation.')
        else:
            makedirs(Config.data_path)
            
    if app_logfile == "True":
        log_config = {
            "version": 1,
            "disable_existing_loggers": False,
            "formatters": {
                "default": {
                    "()": "uvicorn.logging.DefaultFormatter",
                    "fmt": "%(asctime)s - %(levelprefix)s %(message)s",
                    "use_colors": None,
                },
                "access": {
                    "()": "uvicorn.logging.AccessFormatter",
                    "fmt": '%(asctime)s - %(levelprefix)s %(client_addr)s - "%(request_line)s" %(status_code)s',  # noqa: E501
                    "use_colors": None,
                },
            },
            "handlers": {
                "default": {
                    "formatter": "default",
                    "class": "logging.StreamHandler",
                    "stream": "ext://sys.stderr",
                },
                "access": {
                    "formatter": "access",
                    "class": "logging.StreamHandler",
                    "stream": "ext://sys.stdout",
                },
                "file": {
                    "class": "logging.FileHandler",
                    "formatter": "default",
                    "filename": f"{ data_path }uvicorn.log",
                    "mode": "a",
                    "encoding": "utf-8",
                },
            },
            "loggers": {
                "uvicorn": {"handlers": ["default", "file"], "level": "INFO", "propagate": False},
                "uvicorn.error": {"level": "INFO"},
                "uvicorn.access": {"handlers": ["access", "file"], "level": "INFO", "propagate": False},
            },
        }
    else:
        from uvicorn.config import LOGGING_CONFIG
        LOGGING_CONFIG["formatters"]["default"]["fmt"] = "%(asctime)s - %(levelprefix)s %(message)s"
        LOGGING_CONFIG["formatters"]["access"]["fmt"] = '%(asctime)s - %(levelprefix)s %(client_addr)s - "%(request_line)s" %(status_code)s'
        log_config = LOGGING_CONFIG

