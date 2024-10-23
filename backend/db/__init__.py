import sys
sys.path.append('..')
from config.config import Config
from db import initdb

Config.do_config()
initdb.init_db()