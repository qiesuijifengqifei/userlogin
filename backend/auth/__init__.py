import sys
sys.path.append('..')
from config import config
import auth.initdb

config.do_config()
auth.initdb.init_db()