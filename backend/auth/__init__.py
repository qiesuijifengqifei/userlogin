import sys
sys.path.append('..')
from config.config import Config
from auth import initdb

Config.do_config()
initdb.init_db()